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

include("spacecraft.jl")
include("macros.jl")
include("Modules/Modules.jl")
include("Navigation/Navigation.jl")
include("Telemetry/Telemetry.jl")
include("Timing/Timing.jl")
include("Control/Control.jl")


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
    home, io = Telemetry.toggle_logger!(log_path, name, log_level)
    system = System(home)
    system.ios[:file_logger] = io
    sp = connect_to_spacecraft(name, host, port, stream_port, system)
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
    for (_, io) ∈ sp.system.ios
        Base.close(io)
    end
end


end # module SpaceLib
