using KRPC
using SpaceLib


function telemetry_stream(sp::Spacecraft, calls::T) where {K, T<:Tuple{Vararg{RT where {S, P, R, RT<:KRPC.Request{S, P, R}}, K}}}
    KRPC.add_stream(sp.conn, calls)
end


function telemetry_stream(f::Function, sp::Spacecraft, calls::T) where {K, T<:Tuple{Vararg{RT where {S, P, R, RT<:KRPC.Request{S, P, R}}, K}}}
    listener = telemetry_stream(sp, calls)
    try
        f(listener)
    finally
        acquire(sp, :stream)
        close(listener)
        release(sp, :stream)
    end
end


function next(listener::KRPC.Listener)
    KRPC.next_value(listener)
end
