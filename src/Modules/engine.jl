module Engine

using SpaceLib
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

export ignite!

"""
    ignite!(sp::Spacecraft, engine::SCR.Engine; expected_thrust=-1, timeout=-1, thrust_ratio=0.8)

Ignite the engine and wait for expected thrust to be reached.
`expected_thrust` is expected thrust in Newtons. If this is less than 0, a default value is used.
`timeout` is the time in seconds how long to wait until giving up waiting for the engine.
`thrust_ratio` is how much compared to available thrust is used while using default value
"""
function ignite!(sp::Spacecraft, engine::SCR.Engine;
    expected_thrust=-1,
    timeout=-1,
    thrust_ratio=0.9
)
    @log_entry "ignite!"
    SCH.Active!(engine, true)
    expected_thrust = get_expected_thrust(sp, engine, expected_thrust, thrust_ratio)
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
function wait_for_thrust(sp::Spacecraft, engine::SCR.Engine, expected_thrust, timeout)
    t₀ = missing
    t_ignition = missing
    ignition_ok = true
    title = SCH.Name(SCH.Part(engine))
    SpaceLib.Telemetry.ut_periodic_stream(sp, 0.1) do listener
        for now in listener
            if ismissing(t₀)
                t₀ = now
            end
            th = SCH.Thrust(engine)
            if ismissing(t_ignition)
                th == 0 && continue
                @log_trace "$title first light observed" thrust=th
                t_ignition = now
                @log_dev now t_ignition
            else
                if timeout > 0 && (now - t_ignition) > timeout
                    @warn "$title ignition timeout" title
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
    time_spent = sp.system.ut - t_ignition
    @log_exit "$title ignite!" time_spent
    return ignition_ok, time_spent
end

end