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


struct Spacecraft
    conn::KRPC.KRPCConnection
    sc::SCR.SpaceCenter
    ves::SCR.Vessel
    core::ProbeCore
    parts::Dict{Symbol, SCR.Part}
    events::Dict{Symbol, Condition}
    lock::Base.Semaphore

    function Spacecraft(conn::KRPC.KRPCConnection, sc::SCR.SpaceCenter, ves::SCR.Vessel, core::ProbeCore)
        parts = Dict{Symbol, SCR.Part}()
        events = Dict{Symbol, Condition}(:lanunch => Condition(), :abort => Condition())
        sem = Base.Semaphore(1)
        new(conn, sc, ves, core, parts, events, sem)
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
