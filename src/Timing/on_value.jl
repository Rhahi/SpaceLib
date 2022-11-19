function setup__bedrock_altitude(sp::Spacecraft)
    ecef = Navigation.ReferenceFrame.BCBF(sp)
    flight = SCH.Flight(sp.ves, ecef)
    listener = KRPC.add_stream(sp.conn, (SC.Flight_get_BedrockAltitude(flight),))
    value::Float64, = KRPC.next_value(listener)
    listener, sp.system.ut, missing, value, missing
end

function delay__bedrock_altitude(sp::Spacecraft, name=nothing;
    target::Real, timeout::Real=-1, parentid=nothing
)
    @log_timer "delay__bedrock_altitude $target"
    listener, t₀, t₁, h₀, h₁ = setup__bedrock_altitude(sp)
    idv = progress_init(parentid, name)
    idt = progress_init(idv, "⤷timeout")
    try
        for (alt,) in listener
            t₁ = sp.system.ut
            h₁ = alt
            progress_update(idv, min(1, (alt-h₀) / (target-h₀)), name)
            if h₀ > target
                alt ≤ target && break
            else
                alt ≥ target && break
            end
            if timeout > 0
                progress_update(idt, min(1, (t₁-t₀) / timeout, name))
                (t₁ - t₀) ≥ (timeout) && break
            end
            yield()
        end
    finally
        KRPC.close(listener)
        progress_end(idt, name)
        progress_end(idv, name)
    end
    @log_timer "delay__bedrock_altitude complete"
    return h₀, h₁
end
