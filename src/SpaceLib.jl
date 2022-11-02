module SpaceLib

using KRPC
using Logging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

# modules
export Telemetry, Timing, Control, Navigation, Guidance

# types
export Spacecraft, ProbeCore

# functions
export connect_to_spacecraft, main, acquire, release

# conversions
export V2T, T2V, I64, I32, UI32, F64, F32

# macros
export @log_timer, @log_traceloop, @log_trace, @log_exit, @log_entry, @log_dev, @log_guidance
export @log_module, @log_system, @log_ok, @log_mark, @log_attention
export LogTimer, LogTraceLoop, LogTrace, LogExit, LogEntry, LogGuidance, LogDev
export LogModule, LogSystem, LogOk, LogMark, LogAttention

include("loglevels.jl")
include("conversions.jl")
include("spacecraft.jl")
include("Modules/Modules.jl")
include("Navigation/Navigation.jl")
include("Telemetry/Telemetry.jl")
include("Timing/Timing.jl")
include("Control/Control.jl")
include("Guidance/Guidance.jl")


"""Manually connect to spacecraft"""
function connect_to_spacecraft(name::String="Julia",
                               host::String="127.0.0.1",
                               port::Int64=50000,
                               stream_port::Int64=50001,
                               system::System=System())
    @debug "Connecting to spacecraft"
    conn = kerbal_connect(name, host, port, stream_port)
    @debug "Connection complete"
    space_center = SCR.SpaceCenter(conn)
    active_vessel = SCH.ActiveVessel(space_center)
    sp = Spacecraft(conn, space_center, active_vessel, system)
    listener = Telemetry.start_time_server(sp)
    @async Telemetry.start_time_updates(sp, listener)
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
        close(sp)
    end
end


function main(f::Function,
              name::String="Julia",
              host::String="127.0.0.1",
              port::Int64=50000,
              stream_port::Int64=50001;
              log_path::String,
              log_level::LogLevel=LogLevel(0))
    home = Telemetry.home_directory(log_path, name)
    system = System(home)
    sp = connect_to_spacecraft(name, host, port, stream_port, system)
    Telemetry.toggle_logger!(sp, log_level)
    try
        @info "Begin program"
        f(sp)
        @info "End of program"
    finally
        close(sp)
    end
end


function close(sp::Spacecraft)
    @debug "Disconecting KRPC"
    Base.close(sp.conn.conn)
    for (_, io) in sp.system.ios
        Base.close(io)
    end
end
Base.close(sp::Spacecraft) = close(sp::Spacecraft)


end # module SpaceLib
