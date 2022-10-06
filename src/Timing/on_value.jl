import KRPC.Interface.SpaceCenter as SC
using SpaceLib
using SpaceLib.Timing, SpaceLib.Telemetry, SpaceLib.Navigation


function delay_on_bedrock_altitude(sp::Spacecraft, target_alt::Real, timeout::Real)
    acquire(sp, :stream)
    ecef = ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    t₀, h₀, t₁, h₁ = missing, missing, missing, missing
    telemetry_stream(sp, (SC.get_UT(), SC.Flight_get_BedrockAltitude(flight))) do stream
        release(sp, :stream)
        t₀, h₀ = next(stream)
        for (now, alt,) in stream
            t₁ = now
            h₁ = alt
            if h₀ > target_alt
                alt ≤ target_alt && break
            else
                alt ≥ target_alt && break
            end
            (now - t₀) ≥ (timeout) && break
            yield()
        end
        @tracev 2 "delay complete" duration=t₁-t₀ altitude=h₁
    end
    h₀, h₁
end


function delay_on_bedrock_altitude(sp::Spacecraft, target_alt::Real, timeout::Real, name::String)
    acquire(sp, :stream)
    ecef = ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    t₀, h₀, t₁, h₁ = missing, missing, missing, missing
    telemetry_stream(sp, (SC.get_UT(), SC.Flight_get_BedrockAltitude(flight))) do stream
        release(sp, :stream)
        t₀, h₀ = next(stream)
        @withprogress name=name begin
            for (now, alt,) in stream
                t₁ = now
                h₁ = alt
                if h₀ > target_alt
                    @logprogress min(1, (h₀-alt) / target_alt)
                    alt ≤ target_alt && break
                else
                    @logprogress min(1, (alt-h₀) / target_alt)
                    alt ≥ target_alt && break
                end
                (now - t₀) ≥ (timeout) && break
                yield()
            end
        end
        @tracev 2 "delay complete" duration=t₁-t₀ altitude=h₁
    end
    h₀, h₁
end

