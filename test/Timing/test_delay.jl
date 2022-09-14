using SpaceLib
using KRPC.Interface.SpaceCenter as SC
using Dates

@testset "delay" begin
    sp = connect_to_spacecraft()

    t₀ = SC.Helpers.UT(sp.sc)
    SpaceLib.Timing.delay(sp, 2)
    t₁ = SC.Helpers.UT(sp.sc)
    @test t₁ - t₁ ≈ 2

    t₀ = SC.Helpers.UT(sp.sc)
    SpaceLib.Timing.delay(sp, 2.)
    t₁ = SC.Helpers.UT(sp.sc)
    @test t₁ - t₁ ≈ 2

    close(sp.conn.conn)
end
