module Navigation

using SpaceLib
using KerbalMath
using LinearAlgebra
using RemoteLogging.Terminal
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("referenceframe.jl")
include("directions.jl")
include("posvel.jl")
include("drawing.jl")

export ReferenceFrame
export directionsₗ, up, northₗ, eastₗ
export coordinate, velocity

end
