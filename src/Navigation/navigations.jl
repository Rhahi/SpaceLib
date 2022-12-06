"Up direction vector from vessel position. BCBF/BCI only."
up(r) = hat(r)

"Direction parallel to the North Pole of given body."
function pole(body=:earth)
    body == :earth ? (0., 1., 0.) :
    error("Unknown body")
end

"North direction."
north(up, east) = cross(up, east)
northₗ(up, east) = crossₗ(up, east)

"East direction."
east(north_or_pole, up) = cross(north_or_pole, up) |> hat
eastₗ(north_or_pole, up) = crossₗ(north_or_pole, up) |> hat

"Get a collection of basic directions. For use within KRPC."
function directionsₗ(r; body=:earth)
    u = up(r)
    e = eastₗ(pole(body), u)
    n = northₗ(u, e)
    return u, e, n
end

function coordinate(sp::Spacecraft, ref::Symbol)::NTuple{3, Float64}
    ref == :BCBF ? SCH.Position(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end
coordinate(sp::Spacecraft, ref::SCR.ReferenceFrame) = SCH.Position(sp.ves, ref)

function velocity(sp::Spacecraft, ref::Symbol)::NTuple{3, Float64}
    ref == :BCBF ? SCH.Velocity(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end
velocity(sp::Spacecraft, ref::SCR.ReferenceFrame) = SCH.Velocity(sp.ves, ref)

function direction(sp::Spacecraft, ref::Symbol)::NTuple{3, Float64}
    ref == :BCBF ? SCH.Direction(sp.ves, ReferenceFrame.BCBF(sp)) :
    error("Unknown reference")
end
direction(sp::Spacecraft, ref::SCR.ReferenceFrame) = SCH.Direction(sp.ves, ref)

function altitude(sp::Spacecraft; mode=:sealevel)
    flight = SCH.Flight(sp.ves, Navigation.ReferenceFrame.BCBF(sp))
    altitude(flight; mode=mode)
end

function altitude(flight::SCR.Flight; mode=:sealevel)
    mode == :surface ? SCH.SurfaceAltitude(flight) : SCH.BedrockAltitude(flight)
end
