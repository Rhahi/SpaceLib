module Control

import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("staging.jl")
include("throttle.jl")
include("control_loop.jl")

export stage!, throttle, throttle!
export init_direction_control

end
