module Timing

using Logging
using ProgressLogging
using KRPC
import KRPC.Interface.SpaceCenter as SC
using SpaceLib, SpaceLib.Telemetry, SpaceLib.Navigation

include("on_time.jl")
include("on_value.jl")

export delay

export delay__bedrock_altitude

end