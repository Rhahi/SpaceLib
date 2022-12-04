module SpaceLib

using KRPC
using Logging: LogLevel, global_logger
using RemoteLogging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH
import Base: acquire, release, notify, wait

# modules
export Telemetry, Timing, Control, Navigation, Modules

# types
export Spacecraft, LogLevel, Timeserver

# functions
export connect_to_spacecraft, test_spacecraft, connect_to_timeserver
export host_logger, acquire, release, zero!

# macros
export @asyncx, @importkrpc

include("system.jl")
include("connect.jl")
include("Modules/Modules.jl")
include("Navigation/Navigation.jl")
include("Telemetry/Telemetry.jl")
include("Timing/Timing.jl")
include("Control/Control.jl")

end # module SpaceLib
