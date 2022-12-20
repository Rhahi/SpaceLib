module Engine

using SpaceLib
using RemoteLogging
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

export ignite!, burn_time, wait_for_thrust, deltav

const g = 9.80665  # grav acceleration, m/s²

"""
    ignite!(sp::Spacecraft, engine::SCR.Engine; expected_thrust=-1, timeout=-1, thrust_ratio=0.8)

Ignite the engine and wait for expected thrust to be reached.
`expected_thrust` is expected thrust in Newtons. If this is less than 0, a default value is used.
`timeout` is the time in seconds how long to wait until giving up waiting for the engine.
`thrust_ratio` is how much compared to available thrust is used while using default value
"""
function ignite!(sp::Spacecraft, engine::SCR.Engine;
    target_thrust=-1,
    timeout=-1,
    thrust_ratio=0.9
)
    @log_entry "ignite!"
    SCH.Active!(engine, true)
    expected_thrust = get_expected_thrust(sp, engine, target_thrust, thrust_ratio)
    return wait_for_thrust(sp, engine, expected_thrust, timeout)
end

function get_expected_thrust(sp::Spacecraft, engine::SCR.Engine, expected_thrust, thrust_ratio)
    available_thrust = SCH.AvailableThrust(engine) * Control.throttle(sp)
    available_thrust == 0 && @log_attention "there is no available thrust, yet ignite! was called"
    if expected_thrust > 0
        if expected_thrust > available_thrust
            @warn "provided expected thrust is higher than available thrust"
        end
    else
        expected_thrust = available_thrust * thrust_ratio
    end
    return expected_thrust
end

"Wait for engine thrust to reach target. Return how long the engine has been burning since ignition."
function wait_for_thrust(sp::Spacecraft, engine::SCR.Engine, expected_thrust, timeout, polling_period=0.1)
    t_ignition = missing
    ignition_ok = true
    title = SCH.Name(SCH.Part(engine))
    SpaceLib.Telemetry.ut_periodic_stream(sp, polling_period) do listener
        for now in listener
            th = SCH.Thrust(engine)
            if ismissing(t_ignition)
                th == 0 && continue
                @log_trace "$title first light observed"
                t_ignition = now
            else
                if timeout > 0 && (now - t_ignition) > timeout
                    @warn "$title ignition timeout"
                    ignition_ok = false
                    break
                end
            end
            if th ≥ expected_thrust
                @log_module "$title target thrust reached"
                break
            end
        end
    end
    @log_module "Time spent spinning up: $(sp.system.ut - t_ignition)s"
    return ignition_ok
end

"""Rocket equation using specific impulse"""
function deltav(isp::Real, m₀::Real, m₁::Real)
    Δv = isp*g*log(m₀/m₁)
end
ΔV(isp::Real, m₀::Real, m₁::Real) = deltav(isp, m₀, m₁)

"""
Expected burn time of the engine, in seconds.
Devates from MJ value. 0.12 seconds to compute.
"""
function burn_time(sp::Spacecraft, engine::SCR.Engine; count=1)
    ṁ = mass_flow_rate(engine)
    fuelmass = available_fuel_mass(sp, engine)
    return fuelmass / ṁ / count
end

"""Burn time using already-known mass flow rate."""
function burn_time(sp::Spacecraft, engine::SCR.Engine, ṁ::Real; count=1)
    available_fuel_mass(sp, engine) / ṁ / count
end

"""
Mass flow rate of engine.
Deviates from MJ value.
"""
function mass_flow_rate(engine::SCR.Engine)
    thv = SCH.MaxVacuumThrust(engine)
    isp = SCH.VacuumSpecificImpulse(engine)
    ṁ = thv / isp / g
end

"""Available fuel mass, in kg. Computed from engine. 0.020 seconds to compute."""
function available_fuel_mass(sp, engine::SCR.Engine)
    propellants = SCH.Propellants(engine)
    rmin = minimum(SCH.TotalResourceAvailable(p) / SCH.Ratio(p) for p in propellants)
    sum(rmin * SCH.Ratio(p) * SCH.Density(sp.conn, SCH.Name(p)) for p in propellants)
end

end
