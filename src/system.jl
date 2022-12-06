mutable struct System
    home::Union{Nothing, String}
    lock::Dict{Symbol, Base.Semaphore}
    ios::Dict{Symbol, IOStream}
    function System(home=nothing)
        lock = Dict{Symbol, Base.Semaphore}(
            :semaphore => Base.Semaphore(1),
            :iostream => Base.Semaphore(1),
            )
        ios = Dict{Symbol, IOStream}()
        clocks = Vector{Channel{Float64}}()
        new(home, lock, ios, 0., 0., clocks)
    end
end

abstract type Timeserver end

mutable struct METServer <: Timeserver
    stream::KRPC.Listener
    offset::Float64
    ut::Float64
    met::Float64
    clients::Vector{Channel{Float64}}
    METServer(stream, ut, met) = new(stream, 0, ut, met, Vector{Channel{Float64}}())
end

mutable struct UTServer <: Timeserver
    conn::KRPC.KRPCConnection
    stream::KRPC.Listener
    offset::Float64
    ut::Float64
    clients::Vector{Channel{Float64}}
    UTserver(conn, stream) = new(conn, stream, 0, 0, Vector{Channel{Float64}}())
end

struct Spacecraft
    conn::KRPC.KRPCConnection
    sc::SCR.SpaceCenter
    ves::SCR.Vessel
    parts::Dict{Symbol, SCR.Part}
    events::Dict{Symbol, Condition}
    system::System
    ts::METServer
    function Spacecraft(conn::KRPC.KRPCConnection,
                        sc::SCR.SpaceCenter,
                        ves::SCR.Vessel,
                        system::System)
        parts = Dict{Symbol, SCR.Part}()
        stream, ut, met = Telemetry.start_time_server(conn, ves)
        ts = METServer(stream, ut, met)
        @asyncx Telemetry.start_time_updates(ts)
        new(conn, sc, ves, parts, events, system, ts)
    end
end

function zero!(ts::UTServer) ts.offset = ts.ut end
function zero!(ts::METServer) ts.offset = ts.met end

Base.notify(sp::Spacecraft, event::Symbol) = notify(sp.events[event])
Base.wait(sp::Spacecraft, event::Symbol) = wait(sp.events[event])
Base.release(sp::Spacecraft, lock::Symbol) = release(sp.system.lock[lock])
function Base.acquire(sp::Spacecraft, lock::Symbol)
    acquire(sp.system.lock[:semaphore])
    try
        if lock ∈ keys(sp.system.lock)
            acquire(sp.system.lock[lock])
        else
            sem = Base.Semaphore(1)
            sp.system.lock[lock] = sem
            acquire(sem)
        end
    finally
        release(sp.system.lock[:semaphore])
    end
end

macro asyncx(ex)
    quote
        Threads.@spawn try
            $(esc(ex))
        catch e
            @error "Exception in task" exception=(e, catch_backtrace())
        end
    end
end

macro importkrpc(exs...)
    quote
        esc(import KRPC.Interface.SpaceCenter as SC)
        esc(import KRPC.Interface.SpaceCenter.RemoteTypes as SCR)
        esc(import KRPC.Interface.SpaceCenter.Helpers as SCH)
    end
end
