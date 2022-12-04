"""
    filter_direction(sp::Spacecraft, input::Channel{Any}; period=0.05)

- `input`: ODE solution where [1:3] correspond to velocity of the rocket.
- `period`: direction update interval.
- `offset`: offset to apply when extracting velocity from solution.
"""
function filter_solution_to_direction(sp::Spacecraft, input::Channel{Any}; period=0.05, offset=0)
    output = Channel{NTuple{3, Float64}}(1)
    @asyncx begin
        new_solution = take!(input)
        solution = new_solution
        isnothing(solution) && @log_warn "Bad initial solution"
        try
            for _ in Telemetry.ut_periodic_stream(sp, period)
                isopen(input) || break
                if isready(input)
                    new_solution = take!(input)
                    if !isnothing(new_solution)
                        solution = new_solution
                    end
                end
                if !isnothing(solution)
                    time = sp.system.met - offset
                    u = solution(time)
                    put!(output, V2T(view(u, 1:3)))
                end
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @log_warn "Unexpected error during filtering: direction -- $e"
            end
        finally
            close(input)
        end
    end
    return output
end

function filter_vector_limit(sp::Spacecraft, input::Channel{NTuple{3, Float64}};
    degrees_per_second, tolerance=1
)
    output = Channel{NTuple{3, Float64}}(1)
    @asyncx begin
        vecfrom = take!(input)
        past = sp.system.ut
        put!(output, vecfrom)
        try
            while true
                vecto = take!(input)
                if norm(vecfrom) == 0 || norm(vecto) == 0
                    @log_warn "cannot find angle with zero vector, skipping to direct output"
                else
                    now = sp.system.ut
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
            if !isa(e, InvalidStateException)
                @log_warn "Unexpected error during filtering: vector limit -- $e"
            end
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
        Telemetry.ut_periodic_stream(sp, period) do stream
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
                if !isa(e, InvalidStateException)
                    @log_warn "Unexpected error during merging -- $e"
                end
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
                if !isa(e, InvalidStateException)
                    @log_warn "Unexpected error during splitting -- $e"
                end
            finally
                close(input)
            end
        end
    end
    return outputs
end
