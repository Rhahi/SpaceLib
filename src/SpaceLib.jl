module SpaceLib

include("KRPC/KRPC.jl")
include("Telemetry/Telemetry.jl")
include("Timing/Timing.jl")
include("Control/Control.jl")
include("./types.jl")

# export modules
export KRPC, Telemetry, Timing, Control

# export types
export Spacecraft, ProbeCore

end # module SpaceLib
