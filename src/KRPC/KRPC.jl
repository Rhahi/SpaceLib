module KRPC
using PyCall

const krpc = PyNULL()

function __init__()
    copy!(krpc, pyimport("krpc"))
end

export connect, range_safety;
export Spacecraft;

include("./types.jl")
include("./spacecraft.jl")

end # module KRPC