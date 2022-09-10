module SpaceLib

# export modules
export KRPC, Telemetry, Timing, Control

# export types
export Spacecraft, ProbeCore

include("./types.jl")
include("KRPC/KRPC.jl")
include("Telemetry/Telemetry.jl")
include("Timing/Timing.jl")
include("Control/Control.jl")

end # module SpaceLib
