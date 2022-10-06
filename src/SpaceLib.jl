module SpaceLib

using KRPC
using Logging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

# modules
export Telemetry, Timing, Control, Navigation

# types
export Spacecraft, ProbeCore

# functions
export connect_to_spacecraft, main, acquire, release

# macros
export @telemetry, @telemetry_inform, @telemetry_warn, @trace, @tracev, @semaphore

include("types/core.jl")
include("macros.jl")
include("Navigation/Navigation.jl")
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
    space_center = SCR.SpaceCenter(conn)
    active_vessel = SCH.ActiveVessel(space_center)
    core = SpaceLib.find_core(active_vessel)
    sp = Spacecraft(conn, space_center, active_vessel, core)
    @async start_time_server(sp)
    sp
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


function start_time_server(sp::Spacecraft)
    acquire(sp, :stream)
    try
        listener = KRPC.add_stream(conn, (SC.get_UT(),))
        release(sp, :stream)
        for (met,) in listener
            sp.met = met
        end
    catch e
        error("the time server has suffered a critical error.")
    finally
        release(sp, :stream)
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
