using SpaceLib
using Test
using RemoteLogging

@testset "Warnup" begin
    ts = LocalServer()
    SpaceLib.start_time_updates(ts)
    time()
    sleep(0.01)
    @test true
end

@testset "Local time server" begin
    ts = LocalServer()
    try
        SpaceLib.start_time_updates(ts)
        epoch = time()
        sleep(0.5)
        @test 0.4 ≤ (ts.ut - epoch) ≤ 0.6
        sleep(0.5)
        @test 0.9 ≤ (ts.ut - epoch) ≤ 1.1
    finally
        close(ts)
    end
end

@testset "Time server time step" begin
    ts = LocalServer()
    try
        SpaceLib.start_time_updates(ts)
        times = []
        count = 0
        Timing.ut_stream(ts) do chan
            for now in chan
                push!(times, now)
                count += 1
                count == 3 && break
            end
        end
        @test times[3] - times[2] < 0.1
        @test times[2] - times[1] < 0.1
    finally
        close(ts)
    end
end

@testset "Stop time server" begin
    ts = LocalServer()
    SpaceLib.start_time_updates(ts)
    sleep(0.1)
    close(ts)
    @test !isopen(ts.stream)
    @test length(ts.clients) == 0
end
