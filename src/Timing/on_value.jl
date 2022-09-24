using KRPC
import KRPC.Interface.SpaceCenter as SC
using SpaceLib
using SpaceLib.Timing, SpaceLib.Telemetry, SpaceLib.Navigation


function delay_on_bedrock_altitude_deprecated(sp::Spacecraft, target_alt::Float64, timeout::Float64)
    ecef = ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    stream = add_stream(sp.conn, (SC.get_UT(), SC.Flight_get_BedrockAltitude(flight)))
    println("streamadded")
    start_alt = 0.
    final_alt = 0.
    start_time = 0.
    final_time = 0.
    try
        first_loop = true
        for (now, alt,) in stream
            println(now, " ", alt)
            if first_loop
                start_alt = alt
                start_time = now
                first_loop = false
            end
            final_alt = alt
            final_time = now
            if start_alt > target_alt
                alt ≤ target_alt && break
            else
                alt ≥ target_alt && break
            end
            (now - start_time) ≥ (timeout) && break
            yield()
        end
        @tracev 2 "delay complete" duration=final_time-start_time altitude=final_alt
    finally
        close(stream)
    end
    start_time, final_time
end


function delay_on_bedrock_altitude(sp::Spacecraft, target_alt::Float64, timeout::Float64)
    init, start_time, start_alt, final_time, final_alt = true, 0., 0., 0., 0.
    ecef = ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    SpaceLib.Telemetry.stream(sp, [(SC.get_UT,), (SC.Flight_get_BedrockAltitude, flight)]) do src
        for (now, alt,) in src
            if init
                start_time, start_alt = src
                init = false
            end
            final_time, final_alt = now, alt
            if start_alt > target_alt
                alt ≤ target_alt && break
            else
                alt ≥ target_alt && break
            end
            (now - start_time) ≥ (timeout) && break
            yield()
        end
    end
    start_time, final_time
end
