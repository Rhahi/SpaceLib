"""
- `line_length`: length of line to show. Set to 0 to disable.
- `line_color`: color of line to show.
"""
function sink_direction(
    sp::Spacecraft, ap::SCR.AutoPilot, ref::SCR.ReferenceFrame, input::Channel{NTuple{3, Float64}};
    line_length=0, line_color=nothing
)
    @asyncx begin
        try
            @log_entry "begin direction loop"
            line = nothing
            wait(input)
            if line_length > 0
                direction = SCH.Direction(sp.ves, ref)
                line = Navigation.Drawing.add_direction(sp, direction, ref; length=line_length, color=line_color)
            end
            while true
                cmd = take!(input)
                @log_traceloop "direction command issued: $cmd"
                if line_length > 0
                    Navigation.Drawing.update_line!(line; dir=cmd)
                end
                SCH.TargetDirection!(ap, cmd)
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @warn "Unexpected error during control loop: direction" e
            end
        end
        @log_exit "end direction loop"
    end
    nothing
end

function sink_thrust(control::SCR.Control, input::Channel{Float32})
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
                @warn "Unexpected error during control loop: thrust" e
            end
        end
    end
    nothing
end

function sink_engage(ap::SCR.AutoPilot, input::Channel{Bool})
    @asyncx begin
        try
            while true
                cmd = take!(input)
                @log_traceloop "$(cmd ? "" : "dis")engage command issued"
                cmd ? SCH.Engage(ap) : SCH.Disengage(ap)
                yield()
            end
        catch e
            if !isa(e, InvalidStateException)
                @warn "Unexpected error during control loop: master" e
            end
        finally
            SCH.Disengage(ap)
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
                @warn "Unexpected error during control loop: roll" e
            end
        finally
            SCH.Disengage(ap)
        end
    end
    nothing
end
