import Logging: LogLevel, handle_message
import Base: show, isless, convert


function restore_callsite_source_position!(expr, src)
    @assert expr.head == :escape
    @assert expr.args[1].head == :macrocall
    @assert expr.args[1].args[2] isa LineNumberNode
    expr.args[1].args[2] = src
    return expr
end


struct ExtraLogLevel
    level::Int32
    name::String
end


# Debug (-1000)
const LogTimer     = ExtraLogLevel(-900, "Timer")
const LogTrace     = ExtraLogLevel(-800, "Trace")
const LogExit      = ExtraLogLevel(-700, "Exit ")
const LogEntry     = ExtraLogLevel(-600, "Entry")
# Info (0)
const LogModule    = ExtraLogLevel( 300, "🟦 Module")
const LogSystem    = ExtraLogLevel( 400, "🟪 System")
const LogOk        = ExtraLogLevel( 600, "🟩   OK  ")
const LogMark      = ExtraLogLevel( 800, "🟧  Mark ")
# Warn (1000)
const LogAttention = ExtraLogLevel(1500, "🟨  OBS! ")
# Error (2000)


Base.isless(a::ExtraLogLevel, b::LogLevel) = isless(a.level, b.level)
Base.isless(a::LogLevel, b::ExtraLogLevel) = isless(a.level, b.level)
Base.convert(::Type{LogLevel}, level::ExtraLogLevel) = LogLevel(level.level)
Base.convert(::Type{Int32}, level::ExtraLogLevel) = level.level
handle_message(logger::SimpleLogger, level::ExtraLogLevel, args...; kwargs...) = handle_message(logger, convert(LogLevel, level), args...; kwargs...)
Base.show(io::IO, level::ExtraLogLevel) = print(io, level.name)

"""debug information about timing"""
macro log_timer(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogTimer $(exs...))), __source__,)
end

"""trace execution history within a function"""
macro log_trace(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogTrace $(exs...))), __source__,)
end

"""trace exit of a function, usually for long-running or complex calls"""
macro log_exit(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogExit $(exs...))), __source__,)
end

"""trace entry of a function"""
macro log_entry(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogEntry $(exs...))), __source__,)
end

"""status info from a module"""
macro log_module(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogModule $(exs...))), __source__,)
end

"""status info from operating system"""
macro log_system(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogSystem $(exs...))), __source__,)
end

"""mark successful results"""
macro log_ok(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogOk $(exs...))), __source__,)
end

"""mark important milestones"""
macro log_mark(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogMark $(exs...))), __source__,)
end

"""alert user for immediate action"""
macro log_attention(exs...)
    return restore_callsite_source_position!(esc(:($Base.@logmsg LogAttention $(exs...))), __source__,)
end


# also notable colors: 208 for bright orange, 184 for middle yellow, 154 for mildly bright green, 87 for cyan
function show_colors()
    for i in 0:255
        num = rpad(string(i), 3)
        printstyled("test[$num] ", bold=true, color=i)
        printstyled("test[$num] ", bold=false, color=i)
    end
end
