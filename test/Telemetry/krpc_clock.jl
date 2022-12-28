using Test
using SpaceLib
using SpaceLib.Telemetry

@testset "Clock" begin
    connect_to_spacecraft() do sp
        # we did nothing so far, so MET is zero.
        @test sp.system.met == 0
        @test sp.system.ut > 0
        ut₀ = sp.system.ut

        # sleep 1 second, and see that time has elapsed around that
        Timing.delay(sp.ts, 1)
        @test 0.9 ≤ sp.system.ut - ut₀ ≤ 2
    end
end
