using Logging, LoggingExtras
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

    close_io() = begin
        @debug "Closing files"
        close(io1)
        close(io2)
    end
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
    TerminalLogger(stderr, level)
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
