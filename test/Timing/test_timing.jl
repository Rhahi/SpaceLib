using Test
using SpaceLib

@testset "delay" begin
    ts = LocalServer()
    SpaceLib.start_time_updates(ts)
    
    @testset "warmup" begin
        zero!(ts)
        Timing.delay(ts, 0.2)
        @async Timing.delay(ts, 1)
    end

    @testset "single delays" begin
        zero!(ts)
        Timing.delay(ts, 0.5)
        @test 0.4 ≤ time(ts) ≤ 1.1
        Timing.delay(ts, 0.5)
        @test 0.9 ≤ time(ts) ≤ 1.6
    end
    
    @testset "multi delays" begin
        zero!(ts)
        @async Timing.delay(ts, 2)
        @async Timing.delay(ts, 1)
        Timing.delay(ts, 1)
        @test 0.9 ≤ time(ts) ≤ 1.6
    end

    close(ts)
end
