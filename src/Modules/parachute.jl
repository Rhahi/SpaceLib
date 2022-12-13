module Parachute

using KRPC
using SpaceLib
using RemoteLogging
import ..@trigger_event
import KRPC.Interface.SpaceCenter as SC
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

@enum ParachuteState begin
    STOWED=0
    ARMED=2
    SEMI_DEPLOYED=4
    DEPLOYED=6
    CUT=8
end

"""Arm the parachute."""
function arm(part::SCR.Part)
    part |> SCH.Parachute |> arm
end

"""Arm the parachute."""
function arm(chute::SCR.Parachute)
    SCH.Arm(chute)
    @asyncx begin
        sleep(1)
        if !SCH.Armed(chute)
            @log_attention "Parachute was not armed successfully. Retrying..."
            part = SCH.Part(chute)
            @trigger_event part "RealChuteModule" "Arm parachute"
        else
            @log_module "Parachute arm confirmed."
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
        @log_warn "Parachute needs to be armed to be unarmed."
        return
    end
    @trigger_event part "RealChuteModule" "Disarm parachute"
end

end # module
