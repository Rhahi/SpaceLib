macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end


"""Wait for in-game seconds to pass, with a progress bar"""
function delay(sp::Spacecraft, seconds::Real, log::String)
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀, t₁ = missing, missing
    ut_stream(sp) do stream
        @tracev 2 "begin delay" met=sp.system.met seconds
        t₀ = take!(stream)
        @withprogress name=log begin
            for now in stream
                @logprogress min(1, (now-t₀) / seconds)
                t₁ = now
                (now - t₀) ≥ (seconds - @time_resolution) && break
                yield()
            end
            @logprogress 1
        end
        @tracev 1 "delay complete" met=sp.system.met requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end


"""Wait for in-game seconds to pass"""
function delay(sp::Spacecraft, seconds::Real)
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀, t₁ = missing, missing
    ut_stream(sp) do stream
        @tracev 2 "begin delay" met=sp.system.met seconds
        t₀ = take!(stream)
        for now in stream
            t₁ = now
            (now - t₀) ≥ (seconds - @time_resolution) && break
            yield()
        end
        @tracev 1 "delay complete" met=sp.system.met requested=seconds actual=t₁-t₀
    end
    t₀, t₁
end
