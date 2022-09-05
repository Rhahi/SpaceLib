using Logging, LoggingExtras
using TerminalLoggers


function activate_file_logger(filename::String, f_level::LogLevel, c_level::LogLevel)
    console = TerminalLogger(stderr, c_level;)
    file = MinLevelLogger(FileLogger(filename), f_level)
    tee = TeeLogger(console, file)
    global_logger(tee)
end
