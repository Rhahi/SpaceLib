import KRPC.Interface.SpaceCenter as SC
using SpaceLib
using SpaceLib.Timing, SpaceLib.Telemetry, SpaceLib.Navigation


function delay_on_bedrock_altitude(sp::Spacecraft, target_alt::Real, timeout::Real)
    acquire(sp, :stream)
    ecef = ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    init, t₀, h₀, t₁, h₁ = true, missing, missing, missing, missing
    SpaceLib.Telemetry.stream(sp, (SC.get_UT(), SC.Flight_get_BedrockAltitude(flight))) do stream
        release(sp, :stream)
        for (now, alt,) in stream
            if init
                init = false
                t₀ = now
                h₀ = alt
            end
            h₁ = alt
            t₁ = now
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
