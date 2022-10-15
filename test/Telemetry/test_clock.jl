using Test
using SpaceLib
using SpaceLib.Telemetry

@testset "Clock" begin
    connect_to_spacecraft() do sp
        # we did nothing so far, so MET is zero.
        @test sp.met == 0
        @test sp.ut > 0
        ut₀ = sp.ut

        # sleep 1 second, and see that time has elapsed around that
        Timing.delay(sp, 1)
        @test 1 ≤ sp.ut - ut₀ ≤ 2
    end
end
