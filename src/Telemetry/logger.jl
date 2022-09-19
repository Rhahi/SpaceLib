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

    tee = TeeLogger(telemetry, spacelib, console)
    filtered_tee = EarlyFilteredLogger(tee) do log is_spacelib_log(log._module) end
    global_logger(filtered_tee)

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
    EarlyFilteredLogger(logger) do log
        log.group ≠ :telemetry && return true           # if not telemetry, do show
        log.level ≥ Info && return true                 # if telemetry info or higher, do show
        false
    end
end


function filelogger_spacelib(io::IOStream)
    FileLogger(io)
end


function filelogger_telemetry(io::IOStream)
    EarlyFilteredLogger(FileLogger(io)) do log
        log.group == :telemetry
    end
end


"""Check if the log message is coming form our code. Ignore telemetry."""
function is_spacelib_log(_module)
    if root_module(_module) in (:KRPC, :ProtoBuf)
        return false
    end
    return true
end


function root_module(m::Module)
    gp = m
    while (gp ≠ m)
        m = parentmodule(m)
        gp = m
    end
    nameof(gp)
end
