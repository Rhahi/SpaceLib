using Test
using SpaceLib.Telemetry


@testset "Logger" begin
    @test Telemetry.format_MET(0) == "T+00:00:00"
    @test Telemetry.format_MET(1) == "T+00:00:01"
    @test Telemetry.format_MET(61) == "T+00:01:01"
    @test Telemetry.format_MET(661) == "T+00:11:01"
    @test Telemetry.format_MET(3601) == "T+01:00:01"
    @test Telemetry.format_MET(36001) == "T+10:00:01"
    @test Telemetry.format_MET(86401) == "T+(1d)00:00:01"
    @test Telemetry.format_MET(0.1) == "T+00:00:00.100"
    @test Telemetry.format_MET(0.001) == "T+00:00:00.001"
    @test Telemetry.format_MET(1.001) == "T+00:00:01.001"
    @test Telemetry.format_MET(61.001) == "T+00:01:01.001"
    @test Telemetry.format_MET(661.001) == "T+00:11:01.001"
    @test Telemetry.format_MET(3601.001) == "T+01:00:01.001"
    @test Telemetry.format_MET(36001.001) == "T+10:00:01.001"
    @test Telemetry.format_MET(86401.001) == "T+(1d)00:00:01.001"
    @test Telemetry.format_MET(86401.0001) == "T+(1d)00:00:01.000"
    @test Telemetry.format_MET(86401.0006) == "T+(1d)00:00:01.001"
    @inferred Telemetry.format_MET(12345678.901)
    @inferred Telemetry.format_MET(12345678.000)
    @inferred Telemetry.format_MET(12345678)
end