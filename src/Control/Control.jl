module Control

import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("staging.jl")
include("throttle.jl")
include("sinks.jl")
include("sources.jl")
include("filters.jl")

export stage!, throttle, throttle!
export control_direction

end
