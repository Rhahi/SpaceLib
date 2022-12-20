macro time_resolution()
    return Float64(0.019999999552965164 / 2)
end

"""Wait for in-game seconds to pass"""
function delay(ts::Timeserver, seconds::Real, name=nothing; parentid=nothing)
    @log_timer "delay $seconds with log"
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    t₀ = ts.ut
    t₁ = t₀
    id = progress_init(parentid, name)
    try
        ut_stream(ts) do stream
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

"""
anticipate modes
- :full = break when next anticipated value is going to pass 0 (from positive)
- :half = do this, but halve the delta
- :none = don't anticiapte
"""
function wait_for_value(f::Function, ts::Timeserver, args...;
    timeout::Real=-1, period::Real=1, anticipate=:none, name=nothing, parentid=nothing
)
    t₀ = ts.ut
    t₁ = t₀
    first = nothing
    value = nothing
    prev = nothing
    delta = nothing
    ut_periodic_stream(ts, period) do stream
        id = progress_init(parentid, name)
        if timeout > 0
            idt = progress_subinit(id, "timeout")
        end
        try
            for now in stream
                t₁ = now
                value = f(args...)
                value ≤ 0 && break
                if isnothing(first)
                    first = value
                    prev = value
                end
                if anticipate == :full || anticipate == :half
                    delta = value - prev
                    if anticipate == :half
                        delta /= 2
                    end
                    value - delta ≤ 0 && break
                    prev = value
                end
                if timeout > 0
                    (now - t₀) ≥ timeout && break
                    progress_update(idt, (now-t₀)/timeout)
                end
                progress_update(id, (first-value)/first)
                yield()
            end
        finally
            progress_end(id)
            timeout > 0 && progress_end(idt)
        end
    end
    return value
end

function wait_for_true(f::Function, ts::Timeserver, args...;
    timeout::Real=-1, period::Real=1, name=nothing, parentid=nothing
)
    t₀ = ts.ut
    t₁ = t₀
    ut_periodic_stream(ts, period) do stream
        if timeout > 0
            idt = progress_init(parentid, name)
        end
        try
            for now in stream
                f(args...) && break
                if timeout > 0
                    (now - t₀) ≥ timeout && break
                    progress_update(idt, (now-t₀)/timeout)
                end
                yield()
            end
        finally
            timeout > 0 && progress_end(idt)
        end
    end
    return t₀, t₁
end
