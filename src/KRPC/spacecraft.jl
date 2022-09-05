using PyCall


function connect(name::String)
    conn = krpc.connect(name)
    space_center = conn.space_center
    active_vessel = space_center.active_vessel
    core = find_core(active_vessel)
    parts = Dict{String, PyObject}()
    events = Dict{String, Condition}(
        "launch" => Condition(),
        "abort" => Condition(),
    )
    Spacecraft(conn, space_center, active_vessel, core, events, parts)
end


function find_range_safety(part::PyObject)
    modules = part.modules
    for m ∈ modules
        if m.has_action("Range Safety")
            return m.set_action
        end
    end
    error("Core part was not found")
end


function range_safety(core::Core)
    core.range_safety_trigger(trigger("Range Safety", true))
end


function find_core(ves::PyObject)
    core_candidate = ves.parts.with_tag("core")
    if length(core_candidate) > 0
        part = core_candidate[1]
        return Core(part, find_range_safety(part))
    end
    part = ves.parts.all[1]
    return Core(part, find_range_safety(part))
end
