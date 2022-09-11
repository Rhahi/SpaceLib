using SpaceLib
using KRPC
using KRPC.Interface.SpaceCenter.Helpers
import KRPC.Interface.SpaceCenter.RemoteTypes as RemoteTypes


struct ProbeCore
    core::RemoteTypes.Part
    range_safety::Function
end


struct Spacecraft
    conn::KRPC.KRPCConnection
    sc::RemoteTypes.SpaceCenter
    ves::RemoteTypes.Vessel
    core::ProbeCore
    events::Dict{String, Condition}
    parts::Dict{String, RemoteTypes.Part}
end


function find_range_safety_trigger(part::RemoteTypes.Part)
    modules = Modules(part)
    for m ∈ modules
        if HasAction(m, "Range Safety")
            trigger() = SetAction(m, "Range Safety", true)
            return trigger
        end
    end
    error("Core part was not found")
end


function find_core(ves::RemoteTypes.Vessel)
    core_candidate = WithTag(Parts(ves), "core")
    if length(core_candidate) > 0
        part = core_candidate[1]
        return ProbeCore(part, find_range_safety_trigger(part))
    end
    @warn "Could not find part with tag core, using the root part instead"
    part = All(Parts(ves))
    return ProbeCore(part, find_range_safety_trigger(part))
end
