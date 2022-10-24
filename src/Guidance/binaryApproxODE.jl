module BinaryApproxODE

using SpaceLib
using DifferentialEquations
using StaticArrays
import Unitful
import PhysicalConstants.CODATA2018: g_n


struct Stage
    thrust::Float64
    duration::Float64
    m₀::Float64
    m₁::Float64
end


function rhs!(du, u, p, t)
    # states and parameters
    v = SA_F64[u[1], u[2], u[3]]
    r = SA_F64[u[4], u[5], u[6]]
    r̂ = r/norm(r)
    v̂ = v/norm(v)
    stage = p[1]
    τ = 0
    for (i, s) in p
        if t < τ+s.duration
            τ += s.duration
            stage = p[i]
            continue
        end
        break
    end

    # intermediates
    grav = -r̂*g_n  # approximated gravity acceleration
    thrust = thrust(stage, t)*mass(stage, t-τ)

    # assignment
    SA_F64[0, 0, 0, u[1], u[2], u[3]]
end



end
