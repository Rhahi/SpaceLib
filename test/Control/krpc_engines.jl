using Test
using SpaceLib
using SpaceLib.Control, SpaceLib.Timing

@testset "Throttle" begin
    connect_to_spacecraft() do sp
        throttle(sp, 0.5)
        delay(sp, 1)
        @test throttle(sp) ≈ 0.5

        throttle(sp, 1)
        delay(sp, 1)
        @test throttle(sp) ≈ 1

        throttle(sp, 0.)
        delay(sp, 1)
        @test throttle(sp) ≈ 0
    end
end
