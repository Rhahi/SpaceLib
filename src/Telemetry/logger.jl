using Dates, Logging, LoggingExtras
using TerminalLoggers
import SpaceLib


"""Create home directory for this logging session"""
function home_directory(root::String, name::String)
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


"""Enable terminal logging only"""
function toggle_logger(sp::Spacecraft, level::LogLevel)
    console = TerminalLogger(stderr, level)
    filtered_tee = filter_blacklist(console)
    add_met = add_MET(sp, filtered_tee)
    global_logger(add_met)
end


"""Enable file and terminal logging"""
function toggle_logger!(sp::Spacecraft, level::LogLevel)
    io = open(sp.system.home*"/spacelib.log", "a")
    sp.system.ios[:file_logger] = io
    console = TerminalLogger(stderr, level)
    spacelib = is_in_file_blacklist(io)
    tee = TeeLogger(spacelib, console)
    filtered_tee = filter_blacklist(tee)
    add_met = add_MET(sp, filtered_tee)
    global_logger(add_met)
end


"""filter out items to be displayed only for console"""
function is_in_file_blacklist(io)
    logger = FileLogger(io)
    EarlyFilteredLogger(logger) do log
        !(log.group in (:pgbar, :nolog))
    end
end


"""Filter out log spam"""
function filter_blacklist(logger)
    EarlyFilteredLogger(logger) do log
        !(root_module(log._module) in (:ProtoBuf,))
    end
end


function root_module(m::Module)
    gp = m
    while (gp ≠ m)
        m = parentmodule(m)
        gp = m
    end
    nameof(gp)
end


function add_MET(sp::Spacecraft, logger)
    TransformerLogger(logger) do log
        met = format_MET(sp.system.met)
        merge(log, (; message = "$met | $(log.message)"))
    end
end
