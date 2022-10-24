function setup__bedrock_altitude(sp::Spacecraft)
    ecef = ReferenceFrame.BCBF(sp)
    flight = SCH.Flight(sp.ves, ecef)
    listener = add_stream(sp.conn, (SC.Flight_get_BedrockAltitude(flight),))
    value::Float64, = KRPC.next_value(listener)
    listener, sp.system.ut, missing, value, missing
end


function delay__bedrock_altitude(sp::Spacecraft; target::Real, timeout::Real=-1)
    @log_timer "delay__bedrock_altitude $target"
    listener, t₀, t₁, h₀, h₁ = setup__bedrock_altitude(sp)
    try
        for (alt,) in listener
            t₁ = sp.system.ut
            h₁ = alt
            if h₀ > target
                alt ≤ target && break
            else
                alt ≥ target && break
            end
            timeout > 0 && (t₁ - t₀) ≥ (timeout) && break
            yield()
        end
    finally
        KRPC.close(listener)
    end
    @log_timer "delay__bedrock_altitude complete" duration=t₁-t₀ altitude=h₁
    h₀, h₁
end


function delay__bedrock_altitude(sp::Spacecraft, label::String; target::Real, timeout::Real=-1)
    @log_timer "delay__bedrock_altitude $target"
    listener, t₀, t₁, h₀, h₁ = setup__bedrock_altitude(sp)
    try
        if target ≠ h₀
            @withprogress name=label begin
                for (alt,) in listener
                    t₁ = sp.system.ut
                    h₁ = alt
                    @logprogress label min(1, (alt-h₀) / (target-h₀)) _group=:pgbar
                    if h₀ > target
                        alt ≤ target && break
                    else
                        alt ≥ target && break
                    end
                    timeout > 0 && t₁ - t₀ ≥ timeout && break
                    yield()
                end
            end
        end
    finally
        KRPC.close(listener)
    end
    @log_timer "delay__bedrock_altitude complete" duration=t₁-t₀ altitude=h₁
    h₀, h₁
end
