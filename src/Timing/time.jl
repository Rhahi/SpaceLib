using SpaceLib
using PyCall


"""Wait for in-game seconds"""
function delay(sp::Spacecraft, seconds::Float64)
    if seconds <= 0
        return
    end
    t₀ = sp.sc.ut
    t₁ = t₀ + seconds
    t = sp.conn.get_call(py"getattr", sp.sc, "ut")
    expr = sp.conn.krpc.Expression.greater_than(
        sp.conn.krpc.Expression.call(t),
        sp.conn.krpc.Expression.constant_double(t₁))
    event = sp.conn.krpc.add_event(expr)
    Threads.@spawn begin
        try
            event.condition.acquire()
            event.wait()
            @info Threads.threadid(), "second"
        finally
            event.condition.release()
            event.remove()
        end
    end
end
