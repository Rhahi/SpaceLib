using PyCall: PyObject

struct Spacecraft
    conn::PyObject
    sc::PyObject
    ves::PyObject
    core::PyObject
    events::Dict{String, Condition}
    parts::Dict{String, PyObject}
end


struct Core
    core::PyObject
    range_safety_trigger::PyObject
end
