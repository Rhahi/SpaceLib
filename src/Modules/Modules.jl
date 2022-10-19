module Modules

using KRPC
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR

include("macros.jl")
include("core.jl")
include("devtools.jl")
include("parachute.jl")

export PartCore, Parachute

end
