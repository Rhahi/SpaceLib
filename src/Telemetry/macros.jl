using Logging


"""Silent telemetry"""
macro telemetry(exs...)
    quote
        @debug $(exs...) _group=:telemetry
    end
end


"""Rate-limited display telemetry"""
macro telemetry_inform(exs...)
    quote
        @info $(exs...) _group=:telemetry
    end
end


"""Always-show telemetry"""
macro telemetry_warn(exs...)
    quote
        @warn $(exs...) _group=:telemetry
    end
end


"""Log messages for tracing execution. Only for rough information."""
macro trace(exs...)
    quote
        @logmsg LogLevel(-900) $(exs...) _group=:trace
    end
end


"""Log messages for tracing execution, verbose"""
macro tracev(v::Int, exs...)
    quote
        @logmsg LogLevel(-900)-$v $(exs...) _group=:trace
    end
end
