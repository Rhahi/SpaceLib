macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end

"""Wait for in-game seconds to pass"""
function delay(sp::Spacecraft, seconds::Real, name=nothing; parentid=nothing)
    @log_timer "delay $seconds with log"
    if seconds < 0.02
        @log_warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀ = sp.system.ut
    t₁ = t₀
    id = progress_init(parentid, name)
    try
        ut_stream(sp) do stream
            for now in stream
                t₁ = now
                progress_update(id, min(1, (now-t₀) / seconds), name)
                (now - t₀) ≥ (seconds - @time_resolution) && break
                yield()
            end
            @log_timer "delay $seconds complete"
        end
    finally
        progress_end(id, name)
    end
    return t₀, t₁
end
