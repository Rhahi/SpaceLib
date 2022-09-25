"""
Acquire telemetry for logging and for control
"""

module Telemetry

# format

# logger
export toggle_logger!

# stream
export stream

include("format.jl")
include("logger.jl")
include("stream.jl")
include("flight.jl")

end
