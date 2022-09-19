module SpaceLib

using KRPC
using Logging
import KRPC.Interface.SpaceCenter.RemoteTypes as RemoteTypes
import KRPC.Interface.SpaceCenter.Helpers as Helpers

# export modules
export Telemetry, Timing, Control, Navigation

# export types
export Spacecraft, ProbeCore

# export functions
export connect_to_spacecraft, main

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


"""connect_to_spacecraft with automatic connection handling"""
function connect_to_spacecraft(f::Function,
                               name::String="Julia",
                               host::String="127.0.0.1",
                               port::Int64=50000,
                               stream_port::Int64=50001)
    sp = connect_to_spacecraft(name, host, port, stream_port)
    try
        f(sp)
    finally
        close(sp.conn.conn)
    end
end


function main(f::Function,
              name::String="Julia",
              host::String="127.0.0.1",
              port::Int64=50000,
              stream_port::Int64=50001;
              log_path::String,
              log_level::LogLevel=LogLevel(0))
    mkpath(log_path)
    log_io = Telemetry.toggle_logger!(log_path, name, log_level)
    sp = connect_to_spacecraft(name, host, port, stream_port)
    try
        @info "Begin program"
        f(sp)
        @info "End of program"
    finally
        @debug "Disconecting KRPC"
        close(sp.conn.conn)
        for io in log_io
            @debug "Closing IO"
            close(io)
        end
    end
end

end # module SpaceLib
