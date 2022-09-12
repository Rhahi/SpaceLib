module SpaceLib

using KRPC
import KRPC.Interface.SpaceCenter.RemoteTypes as RemoteTypes
import KRPC.Interface.SpaceCenter.Helpers as Helpers

# export modules
export Telemetry, Timing, Control

# export types
export Spacecraft, ProbeCore

# export functions
export connect_to_spacecraft


include("types/core.jl")
include("Telemetry/Telemetry.jl")
include("Timing/Timing.jl")
include("Control/Control.jl")


function connect_to_spacecraft(name::String="Julia",
                               host::String="127.0.0.1",
                               port::Int64=50000,
                               stream_port::Int64=50001)
    @debug "Connecting to spacecraft"
    conn = kerbal_connect(name, host, port, stream_port)
    @debug "Connection complete"
    space_center = RemoteTypes.SpaceCenter(conn)
    active_vessel = Helpers.ActiveVessel(space_center)
    core = SpaceLib.find_core(active_vessel)
    parts = Dict{String, RemoteTypes.Part}()
    events = Dict{String, Condition}(
        "launch" => Condition(),
        "abort" => Condition(),
    )
    Spacecraft(conn, space_center, active_vessel, core, events, parts)
end

end # module SpaceLib
