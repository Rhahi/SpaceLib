module Control

import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("staging.jl")
include("throttle.jl")
include("sinks.jl")
include("sources.jl")
include("filters.jl")

# general rocket control commands
export stage!, throttle, throttle!

# control loop components
export init_autopilot
export filter_direction, filter_spin
export sink_direction, sink_roll, sink_engage, sink_thrust

end
