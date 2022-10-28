import .CelestialBody: Body

function bci_rhs!(du, u, p, t)
    # states and parameters
    v = view(u, 1:3)
    r = view(u, 4:6)
    rnorm  = norm(r)
    vnorm  = norm(v)
    body   = p[1]
    rocket = p[2]
    h = (rnorm)m - body.radius
    stage, burn_time = current_stage(rocket, t)

    # intermediates
    a_grav = gravity_acc(body)
    f_thrust = thrust(stage, burn_time)
    f_drag = drag(stage, (vnorm)m/s, body, h)
    forces = (f_thrust + f_drag) / mass(stage, burn_time)

    # variations
    v_acc = uconvert(m/s^2, forces) |> ustrip
    r_acc = uconvert(m/s^2, a_grav) |> ustrip

    # assignment
    du[1] = v[1]/vnorm*v_acc + r[1]/rnorm*r_acc
    du[2] = v[2]/vnorm*v_acc + r[2]/rnorm*r_acc
    du[3] = v[3]/vnorm*v_acc + r[3]/rnorm*r_acc
    du[4] = u[1]
    du[5] = u[2]
    du[6] = u[3]
end


"""
    thrust(stage, t)

Vaccum thrust of the model rocket.
"""
function thrust(stage::Stage, t)
    isnothing(stage) && return 0N
    t > stage.duration && return 0N
    stage.vac
end


"""
    thrust(stage, body, h)

Thrust of the model rocket, accounting for atmospheric affect.
Assume continuous burn since ignition.
"""
function thrust(stage::Stage, t, body::Body, h::Length)
    if h > body.atmosphere
        return thrust(stage, t)
    end
    isnothing(stage) && return 0N
    stage.vac - (stage.vac - stage.asl) * body.scale(h)
end


"""
    drag(stage, v, body, h, T)

Drag force the model rocket is experiencing.
"""
function drag(stage::Stage, v::Velocity, B::Body, h::Length, T::Temperature=300K)
    if h > B.atmosphere
        return 0N
    end
    0.5 * B.atm_density(h, T) * v^2 * stage.Cd * stage.area
end


"""
    gravity_acc(body, h)

Gravity acceleration the model rocket is experiencing.
"""
function gravity_acc(body::Body, h::Length)
    body.grav*(body.bedrock)^2/(body.bedrock+h)^2
end


"""
    gravity_acc(body)

Gravity acceleration the model rocket is experiencing.
Flat Earth approximation.
"""
function gravity_acc(body::Body)
    body.grav
end


function mass(stage::Stage, t)
    stage.m₀ - min(stage.m₁, stage.ṁ * (t)s)
end
