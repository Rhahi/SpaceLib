using KRPC
using SpaceLib


function stream(sp::Spacecraft, calls::T) where {K, T<:Tuple{Vararg{RT where {S, P, R, RT<:KRPC.Request{S, P, R}}, K}}}
    Base.acquire(sp.lock)
    listener = KRPC.add_stream(sp.conn, calls)
    Base.release(sp.lock)
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
