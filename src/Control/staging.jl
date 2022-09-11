using SpaceLib
using LoggingExtras
import KRPC.Interface.SpaceCenter.Helpers as RC


function stage(sp::Spacecraft)
    @infov 2 "Calling RC stage"
    RC.ActivateNextStage(RC.Control(sp.ves))
end
