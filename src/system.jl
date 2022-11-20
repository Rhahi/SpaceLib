mutable struct System
    home::Union{Nothing, String}
    lock::Dict{Symbol, Base.Semaphore}
    ios::Dict{Symbol, IOStream}
    met::Float64
    ut::Float64
    clocks::Vector{Channel{Float64}}
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

struct Spacecraft
    conn::KRPC.KRPCConnection
    sc::SCR.SpaceCenter
    ves::SCR.Vessel
    parts::Dict{Symbol, SCR.Part}
    events::Dict{Symbol, Condition}
    system::System
    function Spacecraft(conn::KRPC.KRPCConnection,
                        sc::SCR.SpaceCenter,
                        ves::SCR.Vessel,
                        system::System)
        parts = Dict{Symbol, SCR.Part}()
        events = Dict{Symbol, Condition}(
            :lanunch => Condition(),
            :abort => Condition(),
        )
        new(conn, sc, ves, parts, events, system)
    end
end

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
