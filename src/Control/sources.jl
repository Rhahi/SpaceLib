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
        @log_trace "Autopilot initiated while mission hasn't begun"
    end
    if SCH.State(control).value |> ControlState ≠ FULL
        @log_trace "Autopilot initiated while vehicle is not controllable"
    end
    return control, ap
end
