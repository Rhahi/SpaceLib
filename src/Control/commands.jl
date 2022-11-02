@enum ControlState begin
    FULL=0
    PARTIAL=2
    NONE=4
end

"""
    control_direction(sp::Spacecraft, ref::SCR.ReferenceFrame; draw=0, color=nothing)

Native direction control loop using KRPC AutoPilot TargetDirection.
"""
function control_direction(sp::Spacecraft, ref::SCR.ReferenceFrame; draw=0, color=nothing)
    @log_entry "direciton control: starting"
    control = SCH.Control(sp.ves)
    if sp.system.met == 0
        @log_attention "Autopilot does not function while mission hasn't begin."
    end
    if SCH.State(control).value |> ControlState ≠ FULL
        @log_attention "Vessel is not controllable, autopilot may not work."
    end
    ap = SCH.AutoPilot(sp.ves)
    SCH.ReferenceFrame!(ap, ref)
    engage_channel = begin_engage_loop(ap)
    dir_channel = begin_direction_loop(ap, sp, ref, draw)
    th_channel = begin_thrust_loop(control)
    @log_exit "direction control: started"
    return engage_channel, dir_channel, th_channel
end
