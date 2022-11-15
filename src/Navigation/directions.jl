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
