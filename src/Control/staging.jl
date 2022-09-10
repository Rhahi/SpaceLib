using SpaceLib

function stage(sp::Spacecraft)
    sp.ves.control.activate_next_stage()
end
