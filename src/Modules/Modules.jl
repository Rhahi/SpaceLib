module Modules

using KRPC
using SpaceLib
using RemoteLogging.Terminal
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR

include("macros.jl")
include("core.jl")
include("devtools.jl")
include("parachute.jl")
include("engine.jl")

export PartCore, Parachute, Engine

end
