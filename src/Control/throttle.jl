using SpaceLib
import KRPC.Interface.SpaceCenter.Helpers as SCH

"Set main pilot throttle of the spacecraft."
function throttle!(sp::Spacecraft, value::Real)
    @log_trace "throttle: $value"
    control = SCH.Control(sp.ves)
    target_value = clamp(value, 0., 1.)
    SCH.Throttle!(control, convert(Float32, target_value))
end

throttle(control::SCR.Control) = SCH.Throttle(control)
throttle(sp::Spacecraft) = throttle(SCH.Control(sp.ves))

function verify_throttle!(sp::Spacecraft, value::Real, timeout=3)
    throttle!(sp, value)
    Timing.delay(sp, timeout)
    throttle(sp) ≉ value && error("Throttle error")
end
