module Modules

using KRPC
using SpaceLib
using RemoteLogging.Terminal
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("macros.jl")
include("core.jl")
include("devtools.jl")
include("parachute.jl")
include("engine.jl")
include("parts.jl")

export PartCore, Parachute, Engine

end
