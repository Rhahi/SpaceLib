abstract type Rocket end

@kwdef struct Stage{MF<:MassFlow, M<:Mass, F<:Force, S<:Area, Unitless<:Real}
    ṁ::MF
    m₀::M
    m₁::M
    duration::Unitless
    vac::F
    asl::F
    area::S
    Cd::Unitless
end
Stage(ṁ, m₀, m₁, duration, vac) = Stage(ṁ, m₀, m₁, duration, vac, 0N, 0m^2, 0)


"""Collection of rocket stages without any coasting."""
struct HotStageRocket <: Rocket
    stages::Array{Stage, 1}
end


function current_stage(rocket::HotStageRocket, t)
    burn_capability = 0
    previous_stage_burn_time = 0
    for s in rocket.stages
        burn_capability += s.duration
        # if t > sum of all previous stages, it cannot be this stage.
        if t < burn_capability
            previous_stage_burn_time += s.duration
            continue
        end
        return s, t-previous_stage_burn_time
    end
    rocket.stages[end], t-previous_stage_burn_time
end
