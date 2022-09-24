using Test
using SpaceLib
import KRPC.Interface.SpaceCenter as SC

@testset "Altest" begin
    connect_to_spacecraft() do sp
        @testset "basic" begin
            t₀, t₁ = SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 1.)
            @test isapprox(t₁ - t₀, 1, atol=0.02)
        end

        @testset "async with time" begin
            w2 = @async SpaceLib.Timing.delay(sp, 2.)
            w1 = @async SpaceLib.Timing.delay_on_bedrock_altitude(sp, 100., 1.)
            wait(w1)
            wait(w2)
            w1₀, w1₁ = w1.result
            w2₀, w2₁ = w2.result
            @test isapprox(w1₀, w2₀, atol=0.2)
            @test isapprox(w1₁ - w1₀, 1, atol=0.02)
            @test isapprox(w2₁ - w2₀, 2, atol=0.02)
        end
    end
end
