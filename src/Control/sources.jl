@enum ControlState begin
    FULL=0
    PARTIAL=2
    NONE=4
end

function init_autopilot(sp::Spacecraft, ref::SCR.ReferenceFrame)
    @log_entry "Initializing autopilot"
    control = SCH.Control(sp.ves)
    ap = SCH.AutoPilot(sp.ves)
    SCH.ReferenceFrame!(ap, ref)
    if sp.system.met == 0
        @log_attention "Autopilot does not function while mission hasn't begun."
    end
    if SCH.State(control).value |> ControlState ≠ FULL
        @log_attention "Vessel is not controllable, autopilot may not work."
    end
    return control, ap
end
