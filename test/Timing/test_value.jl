using Test
using SpaceLib
import KRPC.Interface.SpaceCenter as SC

@testset "Altitude-time test" begin
    connect_to_spacecraft() do sp
        @testset "Warmup" begin
            w3 = @async Timing.delay(sp, 2.)
            @test typeof(fetch(w3)) <: Tuple
        end

        @testset "Async test" begin
            w1 = @async Timing.delay__bedrock_altitude(sp, target=100., timeout=5.)
            w2 = @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @async Timing.delay(sp, 2.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=1.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            w3 = @async Timing.delay__bedrock_altitude(sp, target=100., timeout=4.)
            @test typeof(fetch(w1)) <: Tuple
            @test typeof(fetch(w2)) <: Tuple
            @test typeof(fetch(w3)) <: Tuple
        end
    end
end
