using SpaceLib
using KRPC
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR


struct ProbeCore
    core::SCR.Part
    range_safety::Function
end


struct Stream
    name::String
    source::KRPC.Listener
    users::Ref{Int64}
    lock::Base.Semaphore

    function Stream(name::String, source::KRPC.Listener)
        new(name, source, 1, Base.Semaphore(1))
    end
end


mutable struct System
    home::String
    lock::Dict{Symbol, Base.Semaphore}
    ios::Dict{Symbol, IOStream}
    met::Float64
    ut::Float64
    clocks::Vector{Channel{Float64}}


    function System(home::String="")
        lock = Dict{Symbol, Base.Semaphore}(
            :stream => Base.Semaphore(1),
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
    core::ProbeCore
    parts::Dict{Symbol, SCR.Part}
    events::Dict{Symbol, Condition}
    system::System

    function Spacecraft(conn::KRPC.KRPCConnection,
                        sc::SCR.SpaceCenter,
                        ves::SCR.Vessel,
                        core::ProbeCore,
                        system::System)
        parts = Dict{Symbol, SCR.Part}()
        events = Dict{Symbol, Condition}(
            :lanunch => Condition(),
            :abort => Condition(),
            )
        new(conn, sc, ves, core, parts, events, system)
    end
end


function find_range_safety_trigger(part::SCR.Part)
    modules = SCH.Modules(part)
    for m ∈ modules
        if SCH.HasAction(m, "Range Safety")
            trigger() = SCH.SetAction(m, "Range Safety", true)
            return trigger
        end
    end
    error("Core part was not found")
end


function find_core(ves::SCR.Vessel)
    core_candidate = SCH.WithTag(SCH.Parts(ves), "core")
    if length(core_candidate) > 0
        part = core_candidate[1]
        return ProbeCore(part, find_range_safety_trigger(part))
    end
    @warn "Could not find part with tag core, using the root part instead"
    part = SCH.All(SCH.Parts(ves))
    return ProbeCore(part, find_range_safety_trigger(part))
end


function release(sp::Spacecraft, lock::Symbol)
    Base.release(sp.system.lock[lock])
end


function acquire(sp::Spacecraft, lock::Symbol)
    Base.acquire(sp.system.lock[:semaphore])
    if lock ∈ keys(sp.system.lock)
        Base.acquire(sp.system.lock[lock])
    else
        sem = Base.Semaphore(1)
        sp.system.lock[lock] = sem
        Base.acquire(sem)
    end
    Base.release(sp.system.lock[:semaphore])
end


function start_time_server(sp::Spacecraft)
    acquire(sp, :stream)
    listener = KRPC.add_stream(sp.conn, (SC.get_UT(), SC.Vessel_get_MET(sp.ves)))
    sp.system.ut, sp.system.met = KRPC.next_value(listener)
    release(sp, :stream)
    listener
end


function start_time_updates(sp::Spacecraft, listener::KRPC.Listener)
    try
        for (ut, met,) in listener
            sp.system.ut = ut
            sp.system.met = met
            for (idx, c) in enumerate(sp.system.clocks)
                try
                    !isready(c) && put!(c, sp.system.ut)
                catch e
                    !isa(e, InvalidStateException) && error(e)
                    deleteat!(sp.system.clocks, idx)
                end
            end
        end
    catch e
        error("the time server has suffered a critical error.")
    finally
        close(listener)
    end
end
