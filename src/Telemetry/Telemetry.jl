"""
Acquire telemetry for logging and for control
"""

module Telemetry

# format

# logger
export toggle_logger!

# macros
export @telemetry, @telemetry_inform, @telemetry_warn
export @trace, @tracev

# stream
export stream

include("format.jl")
include("logger.jl")
include("macros.jl")
include("stream.jl")
include("flight.jl")

end
