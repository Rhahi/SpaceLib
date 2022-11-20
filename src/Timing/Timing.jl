module Timing

using KRPC
using SpaceLib
using SpaceLib.Telemetry
using RemoteLogging.Terminal
@importkrpc

include("on_time.jl")
include("on_value.jl")

export delay
export delay__bedrock_altitude

end