"""Format MET seconds to T+#D ##:##:##[.###] format."""
function format_MET(t::Real)
    D, H, M, S, ms = decompose_time(t)
    hms = join([H, M, S], ':')
    if D ≠ "0"
        return string("T+(", D, "d)", hms, ms)
    end
    return "T+"*hms*ms
end


"""Format UT seconds to # Day ##:##:##[.###] format."""
function format_UT(t::Real)
    D, H, M, S, ms = decompose_time(t)
    hms = join([H, M, S], ':')
    return string(D, " Day ", hms, ms)
end


"""Convert number of seconds into day, hour, minute, second."""
function decompose_time(t::Int64)
    S = lpad(t % 60, 2, '0')
    M = lpad(t ÷ 60 % 60, 2, '0')
    H = lpad(t ÷ 3600 % 24, 2, '0')
    D = string(t ÷ 86400)
    D, H, M, S, ""
end


"""Convert number of seconds into day, hour, minute, second, microsecond"""
function decompose_time(t::Float64)
    milliseconds = string(round(t % 1, digits=2))[2:end]
    seconds = convert(Int64, floor(t))
    D, H, M, S, _ = decompose_time(seconds)
    D, H, M, S, rpad(milliseconds, 3, "0")
end
