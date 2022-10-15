"""
Acquire telemetry for logging and for control
"""

module Telemetry

# format
export format_MET, format_UT

# logger
export toggle_logger!

# stream
export telemetry_stream, next

include("format.jl")
include("logger.jl")
include("stream.jl")
include("flight.jl")

end
