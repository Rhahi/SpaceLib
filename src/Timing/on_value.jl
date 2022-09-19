using KRPC
import KRPC.Interface.SpaceCenter as SC
using SpaceLib
using SpaceLib.Timing, SpaceLib.Telemetry


function delay_on_bedrock_altitude(sp::Spacecraft, target_alt::Float64, timeout::Float64)
    @tracev 1 "delaying for" seconds
    if seconds < 0.02
        @warn "Given time delay is shorter than time resolution (0.02 seconds)"
    end
    ecef = SpaceLib.Navigation.ReferenceFrame.BCBF(sp)
    flight = SpaceLib.Telemetry.get_flight(sp, ecef)
    stream = add_stream(sp.conn, (SC.get_UT(), SC.Flight_get_BedrockAltitude(flight)))
    start_alt = 0.
    final_alt = 0.
    start_time = 0.
    final_time = 0.
    try
        first_loop = true
        for (now, alt,) in stream
            if first_loop
                start_alt = alt
                start_time = now
                first_loop = false
            end
            final_alt = alt
            if start_alt > target_alt
                alt ≤ target_alt && (@tracev 2 "altitude subceeded", break)
            else
                alt ≥ target_alt && (@tracev 2 "altitude exceeded", break)
            end
            (now - start_time) ≥ (timeout) && (@tracev 2 "timeout", break)
            yield()
        end
        @tracev 2 "delay complete" duration=final_time-start_time altitude=final_alt
    finally
        close(stream)
    end
    final_alt
end
