using Test
using SpaceLib

@testset "utstream" begin
    ts = LocalServer()
    SpaceLib.start_time_updates(ts)
    
    @testset "warmup" begin
        t = Timing.ut_stream(ts) do chan
            take!(chan)
            return take!(chan)
        end
        @test t > 0
        t = Timing.ut_periodic_stream(ts, 0.1) do chan
            return take!(chan)
        end
        @test t > 0
    end

    @testset "basic" begin
        res = Timing.ut_stream(ts) do chan
            i = 0
            for (idx, now) in enumerate(chan)
                i += 1
                i > 5 && break
            end
            return i
        end
        @test res == 6
    end

    @testset "basic-async" begin
        task1 = @async begin
            Timing.ut_stream(ts) do chan
                for (idx, now) in enumerate(chan)
                    idx > 300 && return now
                end
            end
        end
        task2 = @async begin
            Timing.ut_stream(ts) do chan
                for (idx, now) in enumerate(chan)
                    idx > 100 && return now
                end
            end
        end
        ref = Timing.ut_stream(ts) do chan
            for (idx, now) in enumerate(chan)
                idx > 200 && return now
            end
        end
        @test fetch(task2) < ref < fetch(task1)
    end
    
    @testset "periodic" begin
        Timing.ut_periodic_stream(ts, 0.5) do chan
            last = nothing
            for (idx, now) in enumerate(chan)
                if !isnothing(last)
                    @test 0.5 ≤ now - last < 1.2
                    idx > 3 && break
                end
                last = now
            end
        end
    end

    close(ts)
end

