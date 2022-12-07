"Begin time server and return initial time and listener"
function start_time_server(conn::KRPC.KRPCConnection, ves::SCR.Vessel)
    listener = KRPC.add_stream(conn, (SC.get_UT(), SC.Vessel_get_MET(ves)))
    ut, met = KRPC.next_value(listener)
    return listener, ut, met
end

"Start ut server with no vessel"
function start_time_server(conn::KRPC.KRPCConnection)
    listener = KRPC.add_stream(conn, (SC.get_UT(),))
    ut, = KRPC.next_value(listener)
    return listener, ut
end

"Start local time server without KRPC for tests"
function start_time_server()
    stream = Channel{Tuple{Float64}}()
    @async begin
        try
            while true
                put!(stream, (time(),))
                sleep(0.02)
            end
        finally
            close(stream)
        end
    end
    stream, time()
end

"Popualte the timeserver with latest time from KRPC"
function start_time_updates(ts::Timeserver)
    try
        for time in ts.stream
            update_timeserver!(ts, time)
            idx_offset = 0
            for (idx, c) in enumerate(ts.clients)
                try
                    !isready(c) && put!(c, ts.ut)
                catch e
                    if !isa(e, InvalidStateException)
                        @error "time server has crashed"
                        error(e)
                    end
                    client = popat!(ts.clients, idx - idx_offset)
                    idx_offset += 1
                    close(client)
                    deleteat!(ts.clients, idx)
                end
            end
        end
    finally
        close(ts.stream)
    end
end

function update_timeserver!(ts::METServer, time::Tuple{Float64, Float64})
    (ts.ut, ts.met) = time
end

function update_timeserver!(ts::Union{UTServer, LocalServer}, time::Tuple{Float64})
    (ts.ut,) = time
end

function ut_stream(ts::Timeserver)
    @log_timer "time channel created"
    channel = Channel{Float64}(1)
    push!(ts.clients, channel)
    channel
end

function ut_stream(f::Function, ts::Timeserver)
    channel = ut_stream(ts)
    try
        f(channel)
    finally
        close(channel)
    end
end

function ut_periodic_stream(ts::Timeserver, period::Real)
    coarse_channel = Channel{Float64}(1)
    fine_channel = ut_stream(ts)
    last_update = 0.
    @async begin
        try
            for now in fine_channel
                if now - last_update > period
                    # skip sending if client hasn't received the time.
                    # this makes sure that every new time update is up to date
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

function ut_periodic_stream(f::Function, ts::Timeserver, period::Real)
    coarse_channel = ut_periodic_stream(ts, period)
    try
        f(coarse_channel)
    finally
        close(coarse_channel)
    end
end
