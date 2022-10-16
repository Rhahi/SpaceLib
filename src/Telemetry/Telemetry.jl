"""
Acquire telemetry for logging and for control
"""

module Telemetry

using SpaceLib

# format
export format_MET, format_UT

# logger
export toggle_logger!

# stream
export telemetry_stream, next, ut_stream

include("csv.jl")
include("format.jl")
include("logger.jl")
include("stream.jl")
include("flight.jl")

end
