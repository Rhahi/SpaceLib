using Test
using SpaceLib
using SpaceLib.Control
using SpaceLib.Modules.Engine
import KRPC.Interface.SpaceCenter.Helpers as SCH

connect_to_spacecraft() do sp
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

    @testset "Engine spinup test" begin
        parts = SCH.Parts(sp.ves)
        engine = SCH.WithTag(parts, "e1")[1] |> SCH.Engine
        status, time_spent = ignite!(sp, engine; timeout=5)
        @test status
        @test 1 < time_spent < 3
        @test SCH.Thrust(engine) > 10000
    end
end
