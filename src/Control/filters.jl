"""
    filter_direction(sp::Spacecraft, input::Channel{Any}; period=0.05)

- `input`: ODE solution where [1:3] correspond to velocity of the rocket.
- `period`: direction update interval.
- `offset`: offset to apply when extracting velocity from solution.
"""
function filter_direction(sp::Spacecraft, input::Channel{Any}; period=0.05, offset=0)
    output = Channel{NTuple{3, Float64}}(1)
    @asyncx begin
        solution = take!(input)
        for _ in Telemetry.ut_periodic_stream(sp, period)
            isopen(input) || break
            if isready(input)
                solution = take!(input)
            end
            time = sp.system.met + offset
            u = solution(time)
            put!(output, view(u, 1:3))
            yield()
        end
    end
    return output
end

"`input` roll increment, in degrees"
function filter_spin(sp::Spacecraft, ref::SCR.ReferenceFrame, input::Channel{Float64}; period=1)
    flight = SCH.Flight(sp.ves, ref)
    output = Channel{Float32}(1)
    @asyncx begin
        Telemetry.ut_periodic_stream(sp, period) do stream
            for _ in stream
                for increment in input
                    roll = SCH.Roll(flight)
                    put!(output, roll+increment)
                    yield()
                end
            end
        end
    end
    return output
end
