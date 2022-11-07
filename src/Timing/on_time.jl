macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end

"""Wait for in-game seconds to pass, with a progress bar"""
function delay(sp::Spacecraft, seconds::Real, log::String)
    @log_timer "delay $seconds with log"
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀ = sp.system.ut
    t₁ = t₀
    ut_stream(sp) do stream
        @withprogress name=log begin
            for now in stream
                t₁ = now
                @logprogress min(1, (now-t₀) / seconds) _group=:pgbar
                (now - t₀) ≥ (seconds - @time_resolution) && break
                yield()
            end
            @logprogress 1 _group=:pgbar
        end
        @log_timer "delay $seconds complete" requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end

"""Wait for in-game seconds to pass"""
function delay(sp::Spacecraft, seconds::Real)
    @log_timer "delay $seconds with log"
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀ = sp.system.ut
    t₁ = t₀
    ut_stream(sp) do stream
        for now in stream
            t₁ = now
            (now - t₀) ≥ (seconds - @time_resolution) && break
            yield()
        end
        @log_timer "delay $seconds complete" requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end
