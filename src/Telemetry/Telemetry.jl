"""
Acquire telemetry for logging and for control
"""

module Telemetry

using KRPC
using SpaceLib
using RemoteLogging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

include("csv.jl")

end
