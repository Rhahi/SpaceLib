using Logging
using ProgressLogging
using KRPC: add_stream
import KRPC.Interface.SpaceCenter as SC
using SpaceLib, SpaceLib.Telemetry


macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end


"""Wait for in-game seconds to pass, with a progress bar"""
function delay(sp::Spacecraft, seconds::Real, log::String)
    @tracev 1 "delaying for" seconds
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀, t₁ = missing, missing
    acquire(sp, :stream)
    telemetry_stream(sp, (SC.get_UT(),)) do stream
        release(sp, :stream)
        t₀, = next(stream)
        @withprogress name=log begin
            for (now,) in stream
                @logprogress min(1, (now-t₀) / seconds)
                t₁ = now
                (now - t₀) ≥ (seconds - @time_resolution) && break
                yield()
            end
            @logprogress 1
        end
        @tracev 2 "sleep complete" requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end


"""Wait for in-game seconds to pass"""
function delay(sp::Spacecraft, seconds::Real)
    @tracev 1 "delaying for" seconds
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀, t₁ = missing, missing
    acquire(sp, :stream)
    telemetry_stream(sp, (SC.get_UT(),)) do stream
        release(sp, :stream)
        t₀, = next(stream)
        for (now,) in stream
            t₁ = now
            (now - t₀) ≥ (seconds - @time_resolution) && break
            yield()
        end
        @tracev 2 "sleep complete" requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end
