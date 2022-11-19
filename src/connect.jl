"""Manually connect to spacecraft. Connection must be done manually."""
function connect_to_spacecraft(name::String="Julia";
    host="127.0.0.1", port=50000, stream_port=50001
)
    @info "Connecting to spacecraft"
    conn = kerbal_connect(name, host, port, stream_port)
    space_center = SCR.SpaceCenter(conn)
    active_vessel = SCH.ActiveVessel(space_center)
    sp = Spacecraft(conn, space_center, active_vessel, System())
    listener = Telemetry.start_time_server(sp)
    @asyncx Telemetry.start_time_updates(sp, listener)
    @info "Connection complete"
    return sp
end

"""
connect_to_spacecraft with automatic connection handling.
Used for non-interactive missions. Use nothing for log_path to use console only.
"""
function connect_to_spacecraft(f::Function, name::String, log_level=LogLevel(-650);
    log_path=nothing, host="127.0.0.1", port=50000, stream_port=50001
)
    sp = connect_to_spacecraft(name; host=host, port=port, stream_port=stream_port)
    s1, s2, _ = host_logger(sp, log_level, log_path, name)
    RemoteLogging.Terminal.activate()
    try
        f(sp)
    finally
        close(sp)
        close(s1)
        close(s2)
    end
    nothing
end

function Base.close(sp::Spacecraft)
    @info "Disconecting KRPC"
    Base.close(sp.conn.conn)
    for (_, io) in sp.system.ios
        Base.close(io)
    end
end

function host_logger(sp, log_level=LogLevel(-650), log_path=nothing, name="Untitled")
    logger = RemoteLogging.spacelogger(sp, log_level; log_path=log_path, log_name=name)
    global_logger(logger)
    return activate_terminal(logger)
end
