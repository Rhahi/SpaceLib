module DevTools

import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR

function list_actions(part::SCR.Part)
    modules = SCH.Modules(part)
    println("--- actions ---")
    for m ∈ modules
        actions = SCH.Actions(m)
        println("Module[$(length(actions))]: ", SCH.Name(m))
        for a ∈ actions
            println("  -> ", a)
        end
    end
end


function list_events(part::SCR.Part)
    modules = SCH.Modules(part)
    println("--- events ---")
    for m ∈ modules
        events = SCH.Events(m)
        println("Module[$(length(events))]: ", SCH.Name(m))
        for e ∈ events
            println("  -> ", e)
        end
    end
end


function list_fields(part::SCR.Part)
    modules = SCH.Modules(part)
    println("--- fields ---")
    for m ∈ modules
        fields = SCH.Fields(m)
        println("Module[$(length(fields))]: ", SCH.Name(m))
        for f ∈ fields
            println("  -> ", f)
        end
    end
end


function list_info(part::SCR.Part)
    println(SCH.Title(part))
    println("")
    list_actions(part)
    println("")
    list_events(part)
    println("")
    list_fields(part)
end

end #module
