function coordinate(sp::Spacecraft, ref::Symbol)
    ref == :BCBF ? SCH.Position(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end

function coordinate(sp::Spacecraft, ref::SCR.ReferenceFrame)
    SCH.Position(sp.ves, ref)
end

function velocity(sp::Spacecraft, ref::Symbol)
    ref == :BCBF ? SCH.Velocity(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end

function velocity(sp::Spacecraft, ref::SCR.ReferenceFrame)
    SCH.Velocity(sp.ves, ref)
end

function direction(sp::Spacecraft, ref::Symbol)
    ref == :BCBF ? SCH.Direction(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end

function direction(sp::Spacecraft, ref::SCR.ReferenceFrame)
    SCH.Direction(sp.ves, ref)
end
