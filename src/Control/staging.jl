using SpaceLib
using LoggingExtras
import KRPC.Interface.SpaceCenter.Helpers as RC


function stage(sp::Spacecraft)
    @infov 2 "Calling RC stage"
    sleep(0.1)  # temporary: must wait for stage:ready condition
    RC.ActivateNextStage(RC.Control(sp.ves))
end
