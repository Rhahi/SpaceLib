using SpaceLib
using SpaceLib.Timing
using LoggingExtras
import KRPC.Interface.SpaceCenter.Helpers as RC


"""
    stage(sp)

Stage the spacecraft.

Wait 0.5625 seconds so that next stage! will work.
Because this acquires :stream for activating next stage, if you somehow need to
stage in the middle of acquired :stream, directly call ActivateNextStage.
"""
function stage(sp::Spacecraft)
    @tracev 2 "enter stage"
    acquire(sp, :stage)
    RC.ActivateNextStage(RC.Control(sp.ves))
    @trace "stage!"
    @async begin
        delay(sp, 0.5625)
        @info "Stage is ready again"
        release(sp, :stage)
    end
end
