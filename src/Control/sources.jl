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
    engage_channel = engage_sink(ap)
    dir_channel = direction_sink(ap, sp, ref, draw)
    th_channel = thrust_sink(control)
    @log_exit "direction control: started"
    return engage_channel, dir_channel, th_channel
end
