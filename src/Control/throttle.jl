using SpaceLib
import KRPC.Interface.SpaceCenter.Helpers as RC


function throttle!(sp::Spacecraft, value::Real)
    @tracev 1 "set throttle" th=value
    control = RC.Control(sp.ves)
    target_value = clamp(value, 0., 1.)
    RC.Throttle!(control, convert(Float32, target_value))
end
