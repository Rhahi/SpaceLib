using Test
using SpaceLib
import KRPC.Interface.SpaceCenter as SC

connect_to_spacecraft() do sp
    clocks = length(sp.system.clocks)

    @testset "delay" begin
        @testset "Basic delay" begin
            t₀, t₁ = Timing.delay(sp.ts, 1)
            @test isapprox(t₁ - t₀, 1, atol=0.02)
            t₀, t₁ = Timing.delay(sp.ts, 1.)
            @test isapprox(t₁ - t₀, 1, atol=0.02)
        end

        @testset "Small time delay" begin
            t₀, t₁ = Timing.delay(sp.ts, 0.2)
            @test isapprox(t₁ - t₀, 0.2, atol=0.02)
            t₀, t₁ = Timing.delay(sp.ts, 0.04)
            @test isapprox(t₁ - t₀, 0.04, atol=0.02)
        end

        @testset "Async time delay" begin
            w1 = @asyncx Timing.delay(sp.ts, 1)
            wait(w1)
            t₀, t₁ = w1.result
            @test isapprox(t₁ - t₀, 1, atol=0.02)
        end

        @testset "Simultaneous delay" begin
            w1 = @asyncx Timing.delay(sp.ts, 1)
            w2 = @asyncx Timing.delay(sp.ts, 2.)
            wait(w1)
            wait(w2)
            w1₀, w1₁ = w1.result
            w2₀, w2₁ = w2.result
            @test isapprox(w1₀, w2₀, atol=0.04)
            @test isapprox(w1₁ - w1₀, 1, atol=0.02)
            @test isapprox(w2₁ - w2₀, 2, atol=0.02)
        end

        @testset "Many parallel delays" begin
            w1 = @asyncx Timing.delay(sp.ts, 1)
            w2 = @asyncx Timing.delay(sp.ts, 2.)
            w3 = @asyncx Timing.delay(sp.ts, 2.)
            w4 = @asyncx Timing.delay(sp.ts, 2.)
            w5 = @asyncx Timing.delay(sp.ts, 2.)
            w6 = @asyncx Timing.delay(sp.ts, 2.)
            wait(w1)
            wait(w2)
            wait(w3)
            wait(w4)
            wait(w5)
            wait(w6)
            w1₀, w1₁ = w1.result
            w2₀, w2₁ = w2.result
            w3₀, w3₁ = w3.result
            w4₀, w4₁ = w4.result
            w5₀, w5₁ = w5.result
            w6₀, w6₁ = w6.result
            @test isapprox(w1₀, w2₀, atol=0.04)
            @test isapprox(w1₁ - w1₀, 1, atol=0.02)
            @test isapprox(w2₁ - w2₀, 2, atol=0.02)
            @test isapprox(w3₁ - w3₀, 2, atol=0.02)
            @test isapprox(w4₁ - w4₀, 2, atol=0.02)
            @test isapprox(w5₁ - w5₀, 2, atol=0.02)
            @test isapprox(w6₁ - w6₀, 2, atol=0.02)
        end
    end

    @testset "verify destruction of clock" begin
        sleep(2)
        @test length(sp.system.clocks) == clocks
    end
end
