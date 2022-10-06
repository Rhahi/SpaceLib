using SpaceLib
import KRPC.Interface.SpaceCenter.Helpers as RC


"Set main pilot throttle of the spacecraft."
function throttle!(sp::Spacecraft, value::Real)
    @tracev 1 "set throttle" th=value
    acquire(sp, :stream) do
        control = RC.Control(sp.ves)
        target_value = clamp(value, 0., 1.)
        RC.Throttle!(control, convert(Float32, target_value))
    end
end
