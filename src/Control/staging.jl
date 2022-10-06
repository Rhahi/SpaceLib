using SpaceLib
using SpaceLib.Timing
using LoggingExtras
import KRPC.Interface.SpaceCenter.Helpers as RC


function stage!(sp::Spacecraft)
    @trace "Stage"
    acquire(sp, :stage)
    acquire(sp, :stream) do
        RC.ActivateNextStage(RC.Control(sp.ves))
    end
    @async begin
        delay(sp, 0.5625)  # Respect KSP "stagingCooldownTimer"
        release(sp, :stage)
    end
end
