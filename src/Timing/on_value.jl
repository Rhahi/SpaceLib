function setup__bedrock_altitude(sp::Spacecraft)
    acquire(sp, :stream)
    ecef = ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    listener = add_stream(sp.conn, (SC.Flight_get_BedrockAltitude(flight),))
    release(sp, :stream)
    value::Float64, = next(listener)
    listener, sp.system.ut, missing, value, missing
end


function delay__bedrock_altitude(sp::Spacecraft; target::Real, timeout::Real=-1)
    listener, t₀, t₁, h₀, h₁ = setup__bedrock_altitude(sp)
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
    @tracev 2 "delay__bedrock_altitude complete" duration=t₁-t₀ altitude=h₁
    h₀, h₁
end


function delay__bedrock_altitude(sp::Spacecraft, label::String; target::Real, timeout::Real=-1)
    listener, t₀, t₁, h₀, h₁ = setup__bedrock_altitude(sp)
    @withprogress name=label begin
        for (alt,) in listener
            t₁ = sp.system.ut
            h₁ = alt
            if h₀ > target
                @logprogress label min(1, (h₀-alt) / target) _group=:pgbar
                alt ≤ target && break
            else
                @logprogress label min(1, (alt-h₀) / target) _group=:pgbar
                alt ≥ target && break
            end
            timeout > 0 && t₁ - t₀ ≥ timeout && break
            yield()
        end
    end
    @tracev 2 "delay__bedrock_altitude complete" duration=t₁-t₀ altitude=h₁
    h₀, h₁
end
