using SpaceLib
using KRPC.Interface.SpaceCenter as SC
using Dates

@testset "delay" begin
    connect_to_spacecraft() do sp
        t₀ = SC.Helpers.UT(sp.sc)
        SpaceLib.Timing.delay(sp, 2)
        t₁ = SC.Helpers.UT(sp.sc)
        @test t₁ - t₁ ≈ 2

        t₀ = SC.Helpers.UT(sp.sc)
        SpaceLib.Timing.delay(sp, 2.)
        t₁ = SC.Helpers.UT(sp.sc)
        @test t₁ - t₁ ≈ 2
    end
end
