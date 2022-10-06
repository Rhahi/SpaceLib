using SpaceLib
using SpaceLib.Timing
using LoggingExtras
import KRPC.Interface.SpaceCenter.Helpers as RC


function stage(sp::Spacecraft)
    @tracev "Stage"
    acquire(sp, :stage)
    RC.ActivateNextStage(RC.Control(sp.ves))
    @async begin
        delay(sp, 0.5625)  # Respect KSP "stagingCooldownTimer"
        release(sp, :stage)
    end
end
