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
export source_spin
export filter_direction
export sink_direction, sink_roll, sink_engage, sink_thrust

end
