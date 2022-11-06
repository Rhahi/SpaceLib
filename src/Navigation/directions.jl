"Up direction vector from vessel position. BCBF/BCI only."
up(r) = hat(r)

"Direction parallel to the North Pole of given body."
function pole(::Tuple, body=:earth)
    body == :earth ? (0., 1., 0.) :
    error("Unknown body")
end
pole(body=:earth) = T2V(pole(Tuple, body))

"North direction."
north(up, east) = cross(T2V(up), T2V(east))

"North direction, left handed vector product."
north(::Tuple, up, east) = V2T(-north(up, east))

"East direction."
east(north_or_pole, up) = cross(T2V(north_or_pole), T2V(up)) |> hat

"East direction, left handed vector product."
east(::Tuple, north_or_pole, up) = -east(north_or_pole, up) |> hat |> V2T

"Get a collection of basic directions. For use within KRPC."
function directions(::Tuple, r; body=:earth)
    u = up(r)
    e = east(Tuple, pole(body), u)
    n = north(Tuple, u, e)
    return u, e, n
end

"Direction vector of length 1. Do not give a vector with length 0."
hat(vec::AbstractVector) = vec / norm(vec)
hat(vec::NTuple{3, Number}) = vec ./ norm(vec)
