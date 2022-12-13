module Timing

using KRPC
using SpaceLib
using SpaceLib.Telemetry
using RemoteLogging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("utstream.jl")
include("on_time.jl")

export delay
export wait_for_true, wait_for_value
export ut_stream, ut_periodic_stream

end
