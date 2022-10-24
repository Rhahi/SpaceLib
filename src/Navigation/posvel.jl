module PosVel

using SpaceLib
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

function position(sp::Spacecraft, ref::SCR.ReferenceFrame)
    SCH.Position(sp.ves, ref)
end


function velocity(sp::Spacecraft, ref::SCR.ReferenceFrame)

end


end  # module
