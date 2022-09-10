using PyCall: PyObject


struct Spacecraft
    conn::PyObject
    sc::PyObject
    ves::PyObject
    core::ProbeCore
    events::Dict{String, Condition}
    parts::Dict{String, PyObject}
end


struct ProbeCore
    core::PyObject
    range_safety_trigger::PyObject
end
