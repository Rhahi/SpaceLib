macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end


"""Wait for in-game seconds to pass, with a progress bar"""
function delay(sp::Spacecraft, seconds::Real, log::String)
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀ = sp.system.ut
    t₁ = t₀
    ut_stream(sp) do stream
        @tracev 2 "begin delay" seconds
        @withprogress name=log begin
            for t₁ in stream
                @logprogress min(1, t₁-t₀ / seconds) _group=:pgbar
                (t₁ - t₀) ≥ (seconds - @time_resolution) && break
                yield()
            end
            @logprogress 1 _group=:pgbar
        end
        @tracev 1 "delay complete" requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end


"""Wait for in-game seconds to pass"""
function delay(sp::Spacecraft, seconds::Real)
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀ = sp.system.ut
    t₁ = t₀
    ut_stream(sp) do stream
        @tracev 2 "begin delay" seconds
        for t₁ in stream
            (t₁ - t₀) ≥ (seconds - @time_resolution) && break
            yield()
        end
        @tracev 1 "delay complete" requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end
