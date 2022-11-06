using Test
using SpaceLib
import KRPC.Interface.SpaceCenter as SC

connect_to_spacecraft() do sp
    clocks = length(sp.system.clocks)

    @testset "periodic time stream" begin
        Telemetry.ut_periodic_stream(sp, 1) do listener
            t1 = take!(listener)
            t2 = take!(listener)
            t3 = take!(listener)
            @test isapprox(t2 - t1, 1, atol=0.03)
            @test isapprox(t3 - t2, 1, atol=0.03)
        end

        Telemetry.ut_periodic_stream(sp, 0.5) do listener
            t1 = take!(listener)
            t2 = take!(listener)
            t3 = take!(listener)
            @test isapprox(t2 - t1, 0.5, atol=0.03)
            @test isapprox(t3 - t2, 0.5, atol=0.03)
        end
    end

    @testset "verify destruction of clock" begin
        sleep(2)
        @test length(sp.system.clocks) == clocks
    end
end
