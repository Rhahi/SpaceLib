using Logging
import SpaceLib

"""Silent telemetry"""
macro telemetry(exs...)
    quote
        @debug $(esc(exs...)) _group=:telemetry
    end
end


"""Rate-limited display telemetry"""
macro telemetry_inform(exs...)
    quote
        @info $(esc(exs...)) _group=:telemetry
    end
end


"""Always-show telemetry"""
macro telemetry_inform(exs...)
    quote
        @warn $(esc(exs...)) _group=:telemetry
    end
end
