function restore_callsite_source_position!(expr, src)
    @assert expr.head == :escape
    @assert expr.args[1].head == :macrocall
    @assert expr.args[1].args[2] isa LineNumberNode
    expr.args[1].args[2] = src
    return expr
end


"""Log messages for tracing execution. Only for rough information."""
macro trace(exs...)
    return restore_callsite_source_position!(
        esc(:($Base.@logmsg Logging.LogLevel(-900) $(exs...))),
        __source__,
    )
end


macro tracev(verbosity::Int, exs...)
    return restore_callsite_source_position!(
        esc(:($Base.@logmsg (Logging.LogLevel(-900) - $verbosity) $(exs...))),
        __source__,
    )
end


macro semaphore(lock, sp, exs...)
    error("this macro is not working correctly!")
    quote
        value = nothing
        acquire($(esc(sp)), $lock)
        try
            value = $(esc(exs...))
        finally
            release($(esc(sp)), $lock)
        end
        value
    end
end
