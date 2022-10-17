"""
Acquire telemetry for logging and for control
"""

module Telemetry

using KRPC
using SpaceLib
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR

# format
export format_MET, format_UT

# logger
export toggle_logger!

# stream
export krpc_stream, next, ut_stream

include("csv.jl")
include("format.jl")
include("logger.jl")
include("stream.jl")

end
