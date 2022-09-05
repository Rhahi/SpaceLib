using Test
using SpaceLib.KRPC

@testset "Basic connection" begin
    s = connect("Basic connection")
    @test s.ves.name == "TestCraft"
    @test KRPC.find_core(s.ves).core.tag == "core"
    s.conn.close()
end

@testset "Part acquisition" begin
    s = connect("Part acquisition")
    @test s.ves.parts.with_tag("core")[1].name == "proceduralAvionics"
    @test s.ves.parts.with_tag("e1")[1].name == "ROE-Veronique"
    s.conn.close()
end

@testset "Range safety" begin
    s = connect("Range safety")
    @test length(s.ves.parts.all) > 0
    range_safety(s.core)
    @test length(s.ves.parts.all) == 0  # vehicle destroyed
    s.conn.close()
end