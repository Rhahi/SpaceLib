using SpaceLib.KRPC
using SpaceLib.Timing

function stage(sp::Spacecraft)
    sp.ves.control.activate_next_stage()
end

