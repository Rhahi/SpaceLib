using Test
using SpaceLib
using SpaceLib.Control
using SpaceLib.Modules.Engine
import KRPC.Interface.SpaceCenter.Helpers as SCH

connect_to_spacecraft("Test", LogLevel(2000)) do sp
    @testset "Warmup" begin
        throttle!(sp, 0.0)
        throttle(sp)
        Timing.delay(sp, 0.5)
    end
    @testset "Main throttle control test" begin
        throttle!(sp, 0.5)
        Timing.delay(sp, 0.5)
        @test throttle(sp) ≈ 0.5

        throttle!(sp, 0.)
        Timing.delay(sp, 0.5)
        @test throttle(sp) ≈ 0

        throttle!(sp, 1)
        Timing.delay(sp, 0.5)
        @test throttle(sp) ≈ 1
    end
end
