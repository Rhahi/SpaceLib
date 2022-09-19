using SpaceLib: Spacecraft
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR


function get_flight(sp::Spacecraft, ref::SCR.ReferenceFrame)
    SCH.Flight(sp.ves, ref)
end
