using SpaceLib
import KRPC.Interface.SpaceCenter.Helpers as SCH


"Set main pilot throttle of the spacecraft."
function throttle(sp::Spacecraft, value::Real)
    @log_entry "throttle: $value"
    control = SCH.Control(sp.ves)
    target_value = clamp(value, 0., 1.)
    SCH.Throttle!(control, convert(Float32, target_value))
    @log_exit "throttle: $value"
end


function throttle(sp::Spacecraft)
    control = SCH.Control(sp.ves)
    return SCH.Throttle(control)
end
