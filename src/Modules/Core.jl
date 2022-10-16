module Core


struct ProbeCore
    core::SCR.Part
    range_safety!::Function
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


end
