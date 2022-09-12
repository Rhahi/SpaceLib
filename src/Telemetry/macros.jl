using Logging
import SpaceLib

"""Special log macro for writing telemetry. Loggers can pick this up separately."""
macro telemetry(exs...)
    quote
        @info $(exs...) _group=:telemetry
    end
end

"""Special log macro for writing telemetry. Loggers can pick this up separately."""
macro telemetry_hidden(exs...)
    quote
        @debug $(exs...) _group=:telemetry
    end
end
