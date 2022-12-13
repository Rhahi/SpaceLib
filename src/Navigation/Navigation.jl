module Navigation

using SpaceLib
using KerbalMath
using LinearAlgebra
using RemoteLogging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("referenceframe.jl")
include("navigations.jl")
include("drawing.jl")

export ReferenceFrame
export directionsₗ, up, northₗ, eastₗ
export coordinate, velocity, altitude

end
