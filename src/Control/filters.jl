"""
interpret incoming solution, typically from simulations, and feed it into a channel.
"""
function filter_solution(interpret::Function, ts::Timeserver, input::Channel{Any};
    period=0.05, offset=0
)
    output = Channel{NTuple{3, Float64}}(1)
    @asyncx begin
        new_solution = take!(input)
        solution = new_solution
        isnothing(solution) && error("Bad initial solution")
        try
            for _ in Telemetry.ut_periodic_stream(ts, period)
                # escape clause
                isopen(input) || break

                # take a new solution
                if isready(input)
                    new_solution = take!(input)
                    isnothing(solution) && break
                    solution = new_solution
                end

                # output
                time = ts.ut - offset
                u = solution(time)
                put!(output, interpret(u))
                yield()
            end
        catch e
            !isa(e, InvalidStateException) && error(e)
        finally
            close(input)
        end
    end
    return output
end

function filter_solution_to_direction(ts::Timeserver, input::Channel{Any};
    period=0.05, offset=0, interpret::Function=(u)->V2T(view(u, 1:3))
)
    filter_solution(interpret, ts, input; period=period, offset=offset)
end

function filter_vector_limit(ts::Timeserver, input::Channel{NTuple{3, Float64}};
    degrees_per_second, tolerance=1
)
    output = Channel{NTuple{3, Float64}}(1)
    @asyncx begin
        vecfrom = take!(input)
        past = ts.ut
        put!(output, vecfrom)
        try
            while true
                vecto = take!(input)
                if norm(vecfrom) == 0 || norm(vecto) == 0
                    @warn "cannot find angle with zero vector, skipping to direct output"
                else
                    now = ts.ut
                    Δθ = ∠θ(vecfrom, vecto)
                    target_diff = (now - past) * deg2rad(degrees_per_second)
                    if Δθ > target_diff
                        # do binary search only if we are overshooting.
                        vecto = vector_binary_search(
                            vecfrom, vecto, target_diff, deg2rad(tolerance)
                        )
                    end
                end
                put!(output, vecto)
                vecfrom, past = vecto, now
                yield()
            end
        catch e
            !isa(e, InvalidStateException) && error(e)
        finally
            close(input)
        end
    end
    return output
end

function vector_binary_search(vecfrom, vecto, target_diff, tolerance)
    overshoot = true
    Δθ = ∠θ(vecfrom, vecto)
    upper = vecto
    lower = vecfrom
    vec = vecto
    while abs(Δθ - target_diff) ≥ tolerance
        if overshoot
            while Δθ > target_diff
                upper = vec
                vec = (lower.+vec)./2
                Δθ = ∠θ(vecfrom, vec)
            end
            overshoot = false
        else
            while Δθ < target_diff
                lower = vec
                vec = (upper.+vec)./2
                Δθ = ∠θ(vecfrom, vec)
            end
            overshoot = true
        end
    end
    return vec
end

"`input` roll increment, in degrees"
function filter_spin(sp::Spacecraft, ref::SCR.ReferenceFrame, input::Channel{Float32}; period=1)
    flight = SCH.Flight(sp.ves, ref)
    output = Channel{Float32}(1)
    @asyncx begin
        increment = take!(input)
        Telemetry.ut_periodic_stream(sp.ts, period) do stream
            for _ in stream
                if isready(input)
                    increment = take!(input)
                end
                roll = SCH.Roll(flight)
                put!(output, roll+increment)
                yield()
            end
        end
    end
    return output
end

function filter_merger(inputs::Channel{T}...) where T <: Any
    output = Channel{T}(1)
    for input in inputs
        @asyncx begin
            try
                while true
                    put!(output, take!(input))
                end
            catch e
                !isa(e, InvalidStateException) && error(e)
            finally
                close(input)
            end
        end
    end
    return output
end

function filter_splitter(input::Channel{T}, count=2) where T <: Any
    outputs = [Channel{T}(1) for _ in 1:count]
    @asyncx begin
        while true
            try
                value = take!(input)
                for output in outputs
                    if !isready(output)
                        put!(output, value)
                    end
                end
            catch e
                !isa(e, InvalidStateException) && error(e)
            finally
                close(input)
            end
        end
    end
    return outputs
end
