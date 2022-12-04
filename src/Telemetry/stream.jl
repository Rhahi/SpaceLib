function start_time_server(sp::Spacecraft)
    listener = KRPC.add_stream(sp.conn, (SC.get_UT(), SC.Vessel_get_MET(sp.ves)))
    sp.system.ut, sp.system.met = KRPC.next_value(listener)
    listener
end

function start_time_server(ts::Timeserver)
    listener = KRPC.add_stream(ts.conn, (SC.get_UT(),))
    ts.zero, = KRPC.next_value(listener)
    ts.ut = ts.zero
    listener
end

function start_time_updates(sp::Spacecraft, listener::KRPC.Listener)
    try
        for (ut, met,) in listener
            sp.system.ut = ut
            sp.system.met = met
            for (idx, c) in enumerate(sp.system.clocks)
                try
                    !isready(c) && put!(c, sp.system.ut)
                catch e
                    !isa(e, InvalidStateException) && error(e)
                    deleteat!(sp.system.clocks, idx)
                end
            end
        end
    catch e
        error("the time server has suffered a critical error $e")
    finally
        close(listener)
    end
end

function start_time_updates(ts::Timeserver, listener::KRPC.Listener)
    try
        for (ut,) in listener
            ts.ut = ut
        end
    finally
        close(listener)
    end
end

function ut_stream(sp::Spacecraft)
    @log_timer "time channel created"
    channel = Channel{Float64}(1)
    push!(sp.system.clocks, channel)
    channel
end

function ut_stream(f::Function, sp::Spacecraft)
    channel = ut_stream(sp)
    try
        f(channel)
    finally
        close(channel)
    end
end

function ut_periodic_stream(sp::Spacecraft, period::Real)
    coarse_channel = Channel{Float64}(1)
    fine_channel = ut_stream(sp)
    last_update = 0.
    @async begin
        try
            for now in fine_channel
                if now - last_update > period
                    if !isready(coarse_channel)
                        put!(coarse_channel, now)
                        last_update = now
                    end
                end
            end
        finally
            close(fine_channel)
        end
    end
    coarse_channel
end

function ut_periodic_stream(f::Function, sp::Spacecraft, period::Real)
    coarse_channel = ut_periodic_stream(sp, period)
    try
        f(coarse_channel)
    finally
        close(coarse_channel)
    end
end
