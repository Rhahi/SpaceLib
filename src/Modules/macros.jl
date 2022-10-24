"""Trigger event of a part using module name and event name."""
macro trigger_event(part, module_name, event_name)
    SCH = KRPC.Interface.SpaceCenter.Helpers
    quote
        for m ∈ $SCH.Modules($(esc(part)))
            if $SCH.Name(m) ≠ $module_name
                continue
            end
            for e ∈ $SCH.Events(m)
                if e == $event_name
                    $SCH.TriggerEvent(m, e)
                    m = $module_name
                    @info "$m: Successfully triggered event [$e]"
                    return
                end
            end
        end
        m, e = $module_name, $event_name
        @warn "$m: Failed to trigger event [$e]"
    end
end
