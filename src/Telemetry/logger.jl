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


"""Get a tee logger with filters enabled"""
function logger(sp::Spacecraft, level::LogLevel, save_file=false)
    if save_file
        io = open(sp.system.home*"/spacelib.log", "a")
        sp.system.ios[:file_logger] = io
        console = TerminalLogger(stderr, level)
        spacelib = io |> FileLogger |> filter_group
        tee = TeeLogger(spacelib, console) |> filter_module
        add_met = add_MET(sp, tee)
    else
        console = TerminalLogger(stderr, level) |> filter_module
        add_met = add_MET(sp, console)
    end
end


function simple_logger(level::LogLevel)
    TerminalLogger(stderr, level) |> filter_module
end


"""filter out items to be displayed only for console"""
function filter_group(logger)
    EarlyFilteredLogger(logger) do log
        !(log.group in (:pgbar, :nolog))
    end
end


"""Filter out log spam"""
function filter_module(logger)
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
