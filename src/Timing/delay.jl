using Logging
using ProgressLogging
using KRPC: add_stream
import KRPC.Interface.SpaceCenter as SC
using SpaceLib, SpaceLib.Telemetry


macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end


function delay_deprecated(sp::Spacecraft, seconds::Float64)
    @tracev 1 "Timed delay for" seconds
    start = SC.Helpers.UT(sp.sc)
    add_stream(sp.conn, (SC.get_UT(),)) do stream
        @tracev 2 "Begin streaming time"
        for (now,) in stream
            now - start > seconds && break
            yield()
        end
    end
    @tracev 2 "Timed delay over"
    start, SC.Helpers.UT(sp.sc)
end


function delay(sp::Spacecraft, seconds::Int64)
    delay(sp, convert(Float64, seconds))
end


function delay(sp::Spacecraft, seconds::Int64, name::String)
    delay(sp, convert(Float64, seconds), name)
end


function delay(sp::Spacecraft, seconds::Float64, name::String)
    @tracev 1 "delaying for" seconds
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    stream = add_stream(sp.conn, (SC.get_UT(),))
    try
        start = 0.
        final = 0.
        @withprogress name=name begin
            for (now,) in stream
                if start == 0
                    start = now
                end
                @logprogress min(1, (now-start) / seconds)
                final = now
                (now - start) ≥ (seconds - @time_resolution) && break
                yield()
            end
            @logprogress 1
        end
        @tracev 2 "sleep complete" requested=seconds actual=final-start
    finally
        close(stream)
    end
    seconds
end


function delay(sp::Spacecraft, seconds::Float64)
    @tracev 1 "delaying for" seconds
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    stream = add_stream(sp.conn, (SC.get_UT(),))
    try
        start = 0.
        final = 0.
        for (now,) in stream
            if start == 0
                start = now
            end
            final = now
            (now - start) ≥ (seconds - @time_resolution) && break
            yield()
        end
        @tracev 2 "sleep complete" requested=seconds actual=final-start
    finally
        close(stream)
    end
    seconds
end
