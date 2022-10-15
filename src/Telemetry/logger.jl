using Dates, Logging, LoggingExtras
using TerminalLoggers
import SpaceLib


"""Create home directory for this logging session"""
function home_directory!(root::String, name::String)
    project_root = string(root, "/", name)
    mkpath(project_root)
    directory_number = -1
    for (root, dirs, files) in walkdir(project_root)
        for d in dirs
            number = tryparse(Int64, d)
            isnothing(number) && continue
            if number > directory_number
                directory_number = number
            end
        end
    end
    home = string(project_root, "/", directory_number+1)
    mkdir(home)
    home
end


function toggle_logger!(level::LogLevel)
    console = display_logger(level)
    filtered_tee = EarlyFilteredLogger(console) do log is_spacelib_log(log._module) end
    global_logger(filtered_tee)
end


"""Enable file and terminal logging. Call the resulting function again to close io."""
function toggle_logger!(root::String, name::String, level::LogLevel)
    home = home_directory!(root, name)
    println(home)
    io = open(home*"/spacelib.log", "a")
    console = display_logger(level)
    spacelib = filelogger_spacelib(io)
    tee = TeeLogger(spacelib, console)
    filtered_tee = EarlyFilteredLogger(tee) do log is_spacelib_log(log._module) end
    global_logger(filtered_tee)

    return io
end


function display_logger(level::LogLevel)
    logger = TerminalLogger(stderr, level)
    EarlyFilteredLogger(logger) do log
        log.group ≠ :telemetry && return true  # if not telemetry, do show
        log.level ≥ Info && return true        # if telemetry info or higher, do show
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


"""Filter out log spam"""
function is_spacelib_log(_module)
    if root_module(_module) in (:ProtoBuf,)
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
