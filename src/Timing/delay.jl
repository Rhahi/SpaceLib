using SpaceLib, SpaceLib.Telemetry
using KRPC
import KRPC.Interface.SpaceCenter as SC


function delay(sp::Spacecraft, seconds::Float64)
    @tracev 1 "Timed delay for" seconds
    start = SC.Helpers.UT(sp.sc)
    add_stream(sp.conn, (SC.get_UT(),)) do stream
        @tracev 2 "Begin streaming time"
        for (now,) in stream
            now - start > seconds && break
            yield()
        end
    end
    @tracev 2 "Timed delay over"
    return start
end


function delay(sp::Spacecraft, seconds::Int64)
    delay(sp, convert(Float64, seconds))
end
