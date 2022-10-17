using SpaceLib
using KRPC
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter as SC

sp = connect_to_spacecraft()
parts = SCH.Parts(sp.ves)
pchute = SCH.WithTag(parts, "chute")[1]
chute = SCH.Parachute(pchute)
SCH.State(chute)
println(chute)
println("Chute state: ", SCH.Armed(chute))
println("Now remove focus from KSP")
sleep(3)
SCH.Arm(chute)
println("Arm command issued")
sleep(1)
println("Chute state: ", SCH.Armed(chute))
