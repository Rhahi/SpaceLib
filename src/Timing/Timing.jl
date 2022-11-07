module Timing

using Logging
using ProgressLogging
using KRPC
using SpaceLib
using SpaceLib.Telemetry
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("on_time.jl")
include("on_value.jl")

export delay
export delay__bedrock_altitude

end