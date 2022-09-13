"""
Acquire telemetry for logging and for control
"""

module Telemetry

export @telemetry, @telemetry_inform, toggle_logger!

include("./format.jl")
include("./logger.jl")
include("./macros.jl")

end
