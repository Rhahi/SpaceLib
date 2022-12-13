module Timing

using KRPC
using SpaceLib
using SpaceLib.Telemetry
using RemoteLogging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("on_time.jl")
include("on_value.jl")

export delay
export delay__bedrock_altitude
export wait_for_true, wait_for_value

end
