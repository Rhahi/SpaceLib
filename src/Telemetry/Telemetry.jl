"""
Acquire telemetry for logging and for control
"""

module Telemetry

using Dates
using KRPC
using SpaceLib
using RemoteLogging.Terminal
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR

# format
export format_MET, format_UT

# logger
export toggle_logger!

# stream
export ut_stream, ut_periodic_stream

include("csv.jl")
include("stream.jl")

end
