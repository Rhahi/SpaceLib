function direction_sink(ap::SCR.AutoPilot, sp::Spacecraft, ref, draw, color=nothing)
    channel = Channel{AbstractVector{Float64}}(1)
    @asyncx begin
        try
            @log_entry "begin direction loop"
            line = nothing
            wait(channel)
            if draw > 0
                direction = SCH.Direction(sp.ves, ref)
                line = Navigation.Drawing.add_direction(sp, direction, ref; length=draw, color=color)
            end
            while true
                cmd = take!(channel)
                target = V2T(cmd)
                @log_traceloop "direction command issued: $target"
                if draw > 0
                    Navigation.Drawing.update_line!(line; dir=target)
                end
                SCH.TargetDirection!(ap, target)
            end
        catch e
            if !isa(e, InvalidStateException)
                @warn "Unexpected error during control loop: direction" e
            end
        end
        @log_exit "end direction loop"
    end
    channel
end

function thrust_sink(control::SCR.Control)
    channel = Channel{Real}(1)
    @asyncx begin
        try
            @log_entry "begin thrust loop"
            while true
                cmd = take!(channel)
                @log_traceloop "throttle command issued: $cmd"
                SCH.Throttle!(control, F32(cmd))
            end
        catch e
            if !isa(e, InvalidStateException)
                @warn "Unexpected error during control loop: thrust" e
            end
        end
    end
    channel
end

function engage_sink(ap::SCR.AutoPilot)
    channel = Channel{Bool}(1)
    @asyncx begin
        try
            while true
                cmd = take!(channel)
                @log_traceloop "$(cmd ? "" : "dis")engage command issued"
                cmd ? SCH.Engage(ap) : SCH.Disengage(ap)
            end
        catch e
            if !isa(e, InvalidStateException)
                @warn "Unexpected error during control loop: master" e
            end
        finally
            SCH.Disengage(ap)
        end
    end
    channel
end


function roll_sink(ap::SCR.AutoPilot)
    channel = Channel{Float64}(1)
    @asyncx begin
        try
            while true
                cmd = take!(channel)
                @log_traceloop "target roll command issued: $(cmd)"
                SCH.TargetRoll!(ap, F32(cmd))
            end
        catch e
            if !isa(e, InvalidStateException)
                @warn "Unexpected error during control loop: roll" e
            end
        finally
            SCH.Disengage(ap)
        end
    end
    channel
end
