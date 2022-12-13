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
