using SpaceLib
import KRPC.Interface.SpaceCenter.Helpers as RemoteCalls


function stage(s::Spacecraft)
    RemoteCalls.ActivateNextStage(s.ves)
end
