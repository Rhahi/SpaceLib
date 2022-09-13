"""
Acquire telemetry for logging and for control
"""

module Telemetry

export toggle_logger!
export @telemetry, @telemetry_inform, @telemetry_warn
export @trace, @tracev

include("format.jl")
include("logger.jl")
include("macros.jl")

end
