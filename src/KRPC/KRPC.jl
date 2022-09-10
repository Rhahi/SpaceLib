module KRPC
using PyCall

const krpc = PyNULL()

function __init__()
    copy!(krpc, pyimport("krpc"))
end

export connect, range_safety

include("./spacecraft.jl")

end # module KRPC
