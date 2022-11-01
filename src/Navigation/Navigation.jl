module Navigation

using SpaceLib
using LinearAlgebra
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("referenceframe.jl")
include("directions.jl")
include("posvel.jl")
include("drawing.jl")

export ReferenceFrame
export directions, up, north, east
export coordinate, velocity

end
