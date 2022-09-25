using Test
using SpaceLib
import KRPC.Interface.SpaceCenter as SC

@testset "Altitude-time test" begin
    connect_to_spacecraft() do sp
        @testset "Warmup" begin
            w3 = @async SpaceLib.Timing.delay(sp, 2.)
            @test typeof(fetch(w3)) <: Tuple
        end

        @testset "Async test" begin
            w1 = @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 5.)
            w2 = @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 4.)
            w3 = @async SpaceLib.Timing.delay(sp, 2.)
            @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 4.)
            @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 4.)
            @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 1.)
            @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 4.)
            @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 4.)
            @test typeof(fetch(w1)) <: Tuple
            @test typeof(fetch(w2)) <: Tuple
        end
    end
end
