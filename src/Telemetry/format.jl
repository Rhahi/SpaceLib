"""Format float MET time to T+#D ##:##:##.### format."""
function format_MET(t::Float64)
    milliseconds = round(t % 1, digits=3)
    seconds = convert(Int64, floor(t))
    return format_MET(seconds)*rpad(milliseconds, 5, '0')[2:end]
end


"""Format int MET time to T+#D ##:##:## format."""
function format_MET(t::Int64)
    S = lpad(t % 60, 2, '0')
    M = lpad(t ÷ 60 % 60, 2, '0')
    H = lpad(t ÷ 3600 % 24, 2, '0')
    D = t ÷ 86400
    hms = join([H, M, S], ':')
    if D > 0
        return string("T+(", D, "d)", hms)
    end
    return "T+"*hms
end

