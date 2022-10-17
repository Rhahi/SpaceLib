function start_time_server(sp::Spacecraft)
    listener = KRPC.add_stream(sp.conn, (SC.get_UT(), SC.Vessel_get_MET(sp.ves)))
    sp.system.ut, sp.system.met = KRPC.next_value(listener)
    listener
end


function start_time_updates(sp::Spacecraft, listener::KRPC.Listener)
    try
        for (ut, met,) in listener
            sp.system.ut = ut
            sp.system.met = met
            for (idx, c) in enumerate(sp.system.clocks)
                try
                    !isready(c) && put!(c, sp.system.ut)
                catch e
                    !isa(e, InvalidStateException) && error(e)
                    deleteat!(sp.system.clocks, idx)
                end
            end
        end
    catch e
        error("the time server has suffered a critical error.")
    finally
        close(listener)
    end
end


function ut_stream(sp::Spacecraft)
    channel = Channel{Float64}(1)
    push!(sp.system.clocks, channel)
    channel
end


function ut_stream(f::Function, sp::Spacecraft)
    channel = ut_stream(sp)
    try
        f(channel)
    finally
        close(channel)
    end
end
