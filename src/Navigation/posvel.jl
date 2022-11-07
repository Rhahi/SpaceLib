function coordinate(sp::Spacecraft, ref::Symbol)
    ref == :BCBF ? SCH.Position(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end
coordinate(sp::Spacecraft, ref::SCR.ReferenceFrame) = SCH.Position(sp.ves, ref)

function velocity(sp::Spacecraft, ref::Symbol)
    ref == :BCBF ? SCH.Velocity(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end
velocity(sp::Spacecraft, ref::SCR.ReferenceFrame) = SCH.Velocity(sp.ves, ref)

function direction(sp::Spacecraft, ref::Symbol)
    ref == :BCBF ? SCH.Direction(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end
direction(sp::Spacecraft, ref::SCR.ReferenceFrame) = SCH.Direction(sp.ves, ref)
