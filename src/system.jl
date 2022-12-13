macro asyncx(ex)
    quote
        Threads.@spawn try
            $(esc(ex))
        catch e
            @error "Exception in task" exception=(e, catch_backtrace())
        end
    end
end

"Other subsystems required for Spacecraft but not part of a spacecraft"
struct System
    home::Union{Nothing, String}
    lock::Dict{Symbol, Base.Semaphore}
    ios::Dict{Symbol, IOStream}
    function System(home=nothing)
        lock = Dict{Symbol, Base.Semaphore}(
            :semaphore => Base.Semaphore(1),
            :iostream => Base.Semaphore(1),
            )
        ios = Dict{Symbol, IOStream}()
        new(home, lock, ios)
    end
end

abstract type Timeserver end

"mission time server that require a vessel to be available"
mutable struct METServer <: Timeserver
    stream::KRPC.Listener
    offset::Float64
    ut::Float64
    met::Float64
    clients::Vector{Channel{Float64}}
    function METServer(conn::KRPC.KRPCConnection, ves::SCR.Vessel)
        stream, ut, met = Telemetry.start_time_server(conn, ves)
        new(stream, 0, ut, met, Vector{Channel{Float64}}())
    end
end

"Standalone time server providing universal time only"
mutable struct UTServer <: Timeserver
    conn::KRPC.KRPCConnection
    stream::KRPC.Listener
    offset::Float64
    ut::Float64
    clients::Vector{Channel{Float64}}
    function UTserver(conn)
        stream, ut = Telemetry.start_time_server(conn)
        new(conn, stream, 0, ut, Vector{Channel{Float64}}())
    end
end

mutable struct LocalServer <: Timeserver
    stream::Channel{Tuple{Float64}}
    offset::Float64
    ut::Float64
    clients::Vector{Channel{Float64}}
    function LocalServer()
        stream, ut = Telemetry.start_time_server()
        new(stream, 0, ut, Vector{Channel{Float64}}())
    end
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
        events = Dict{Symbol, Condition}()
        ts = METServer(conn, ves)
        @asyncx Telemetry.start_time_updates(ts)
        new(conn, sc, ves, parts, events, system, ts)
    end
end

"Set time offset to current time"
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

macro importkrpc(exs...)
    quote
        esc(import KRPC.Interface.SpaceCenter as SC)
        esc(import KRPC.Interface.SpaceCenter.RemoteTypes as SCR)
        esc(import KRPC.Interface.SpaceCenter.Helpers as SCH)
    end
end

"Begin time server and return initial time and listener"
function start_time_server(conn::KRPC.KRPCConnection, ves::SCR.Vessel)
    listener = KRPC.add_stream(conn, (SC.get_UT(), SC.Vessel_get_MET(ves)))
    ut, met = KRPC.next_value(listener)
    return listener, ut, met
end

"Start ut server with no vessel"
function start_time_server(conn::KRPC.KRPCConnection)
    listener = KRPC.add_stream(conn, (SC.get_UT(),))
    ut, = KRPC.next_value(listener)
    return listener, ut
end

"Start local time server without KRPC for tests"
function start_time_server()
    stream = Channel{Tuple{Float64}}()
    @async begin
        try
            while true
                put!(stream, (time(),))
                sleep(0.005)
            end
        finally
            close(stream)
        end
    end
    stream, time()
end

"""
Popualte the timeserver with latest time from KRPC.
When `ts` is closed, this will thorw silently.
"""
function start_time_updates(ts::Timeserver)
    while true
        update_timeserver!(ts, take!(ts.stream))
        idx_offset = 0
        for (idx, c) in enumerate(ts.clients)
            try
                !isready(c) && put!(c, ts.ut)
            catch e
                if !isa(e, InvalidStateException)
                    @error "time server has crashed"
                    error(e)
                end
                client = popat!(ts.clients, idx - idx_offset)
                idx_offset += 1
                close(client)
                deleteat!(ts.clients, idx)
            end
        end
    end
end

function update_timeserver!(ts::METServer, time::Tuple{Float64, Float64})
    (ts.ut, ts.met) = time
end

function update_timeserver!(ts::Union{UTServer, LocalServer}, time::Tuple{Float64})
    (ts.ut,) = time
end
