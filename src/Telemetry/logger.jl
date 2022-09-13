using Dates, Logging, LoggingExtras
using TerminalLoggers
import SpaceLib


"""Enable file and terminal logging. Call the resulting function again to close io."""
function toggle_logger!(directory::String, filename::String, level::LogLevel)
    console = display_logger(level)


    io1 = open(get_available_filename(directory, filename, "telemetry"), "a")
    telemetry = filelogger_telemetry(io1)
    io2 = open(get_available_filename(directory, filename, "spacelib"), "a")
    spacelib = filelogger_spacelib(io2)

    file_loggers = TeeLogger(telemetry, spacelib)
    tee = TeeLogger(console, file_loggers)
    global_logger(tee)

    return io1, io2
end


function get_available_filename(directory::String, filename::String, suffix::String)
    directory = rstrip(directory, '/')
    number = 0
    barename = directory * "/" * filename * "_" * suffix
    path_to_test = barename * "_" * string(number)
    while isfile(path_to_test * ".log")
        number += 1
        path_to_test = barename * "_" * string(number)
    end
    path_to_test * ".log"
end


function display_logger(level::LogLevel)
    logger = TerminalLogger(stderr, level)
    history = Dict{Symbol, DateTime}()
    EarlyFilteredLogger(logger) do log
        is_spacelib_log(log._module) || return false  # if not spacelib, don't show.
        log.group ≠ :telemetry && return true  # if not telemetry, do show
        log.level ≥ Warn && return true # if telemetry warning, do show

        # otherwise, only show sparingly.
        if !haskey(history, log.id) || (Second(1) < now() - history[log.id])
            # then we will log it, and update record of when we did
            history[log.id] = now()
            return true
        else
            return false
        end
    end
end


function filelogger_spacelib(io::IOStream)
    spacelog_file = FileLogger(io)
    EarlyFilteredLogger(spacelog_file) do log
        is_spacelib_log(log._module)
    end
end


function filelogger_telemetry(io::IOStream)
    telemetry = FileLogger(io)
    EarlyFilteredLogger(telemetry) do log
        log.group == :telemetry
    end
end


"""Check if the log message is coming form our code. Ignore telemetry."""
function is_spacelib_log(_module)
    if nameof(_module) == :Telemetry
        return false
    end
    if root_module(_module) in (:KRPC, :SpaceLib, :MissionLib, :Main)
        return true
    end
    return false
end


function root_module(m::Module)
    gp = m
    while (gp ≠ m)
        m = parentmodule(m)
        gp = m
    end
    nameof(gp)
end
