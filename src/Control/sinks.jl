"""
- `line_length`: length of line to show. Set to 0 to disable.
- `line_color`: color of line to show.
"""
function sink_direction(
    sp::Spacecraft, ap::SCR.AutoPilot, ref::SCR.ReferenceFrame, input::Channel{NTuple{3, Float64}};
    line_length=0, line_color=nothing
)
    @asyncx begin
        line = nothing
        try
            @log_entry "begin direction loop"
            wait(input)
            while true
                cmd = take!(input)
                if norm(cmd) == 0
                    @log_warn "skipping direction command with 0-vector"
                    yield()
                    continue
                end
                @log_traceloop "direction command issued: $cmd"
                if line_length > 0
                    if isnothing(line)
                        line = Navigation.Drawing.add_direction(sp, cmd, ref; length=line_length, color=line_color)
                    else
                        Navigation.Drawing.update_line!(line; dir=cmd, length=line_length)
                    end
                end
                SCH.TargetDirection!(ap, cmd)
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @log_warn "Unexpected error during control loop: direction -- $e"
            end
        finally
            Navigation.Drawing.remove!(line)
            close(input)
        end
        @log_exit "end direction loop"
    end
    nothing
end

function sink_throttle(control::SCR.Control, input::Channel{Float32})
    @asyncx begin
        try
            @log_entry "begin thrust loop"
            while true
                cmd = take!(input)
                @log_traceloop "throttle command issued: $cmd"
                SCH.Throttle!(control, cmd)
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @log_warn "Unexpected error during control loop: thrust -- $e"
            end
        finally
            close(input)
        end
    end
    nothing
end

function sink_engage(ap::SCR.AutoPilot, input::Channel{Bool})
    @asyncx begin
        try
            while true
                cmd = take!(input)
                @log_status "$(cmd ? "" : "dis")engage command issued"
                cmd ? SCH.Engage(ap) : SCH.Disengage(ap)
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @log_warn "Unexpected error during control loop: master -- $e"
            end
        finally
            SCH.Disengage(ap)
            close(input)
        end
    end
    nothing
end

function sink_roll(ap::SCR.AutoPilot, input::Channel{Float32})
    @asyncx begin
        try
            while true
                cmd = take!(input)
                @log_traceloop "target roll command issued: $(cmd)"
                SCH.TargetRoll!(ap, cmd)
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @log_warn "Unexpected error during control loop: roll -- $e"
            end

function sink_injector(main::Channel{T}, other::Channel{T}) where T <: Any
    @asyncx begin
        try
            while true
                put!(main, take!(other))
                yield()
            end
        catch e
            !isa(e, InvalidStateException) && error(e)
        finally
            close(other)
        end
    end
    nothing
end

function sink_injector(f::Function, main::Channel{T}, other::Channel{T}) where T <: Any
    sink_injector(main, other)
    try
        f()
    finally
        close(other)
    end
    nothing
end
