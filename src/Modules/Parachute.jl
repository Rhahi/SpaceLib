module Parachute

using SpaceLib
using KRPC
import KRPC.Interface.SpaceCenter.Helpers as SCH
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR


@enum ParachuteState begin
    STOWED=0
    ARMED=2
    SEMI_DEPLOYED=4
    DEPLOYED=6
    CUT=8
end


"""Arm the parachute."""
function arm(part::SCR.Part)
    chute = SCH.Parachute(part)
    SCH.Arm(chute)
    @async begin
        sleep(1)
        if !SCH.Armed(chute)
            @warn "Parachute was not armed successfully."
        else
            @info "Parachute arm confirmed."
        end
    end
end


"""Attempt to immediately deploy parachute."""
function deploy(part::SCR.Part)
    part |> SCH.Parachute |> SCH.Deploy
end


function unarm(part::SCR.Part)
    chute = SCH.Parachute(part)
    if SCH.State(chute).value |> ParachuteState ≠ ARMED
        @warn "Parachute needs to be armed to be unarmed."
        return
    end
    @trigger_event part "RealChuteModule" "Disarm parachute"
end

end # module
