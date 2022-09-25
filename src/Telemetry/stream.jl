using KRPC
using SpaceLib


function stream(sp::Spacecraft, calls::T) where {K, T<:Tuple{Vararg{RT where {S, P, R, RT<:KRPC.Request{S, P, R}}, K}}}
    listener = nothing
    Base.acquire(sp.lock[:source]) do
        listener = KRPC.add_stream(sp.conn, calls)
    end
    listener
end


function stream(f::Function, sp::Spacecraft, calls::T) where {K, T<:Tuple{Vararg{RT where {S, P, R, RT<:KRPC.Request{S, P, R}}, K}}}
    listener = stream(sp, calls)
    try
        f(listener)
    finally
        close(listener)
    end
end
