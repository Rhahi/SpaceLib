"""Write headers for csv and open an IOStream"""
function start_csv!(path::String, headers::Tuple{Vararg{Symbol}})
    io = open(path, "a")
    write(io, "ut,met,"*join(headers, ',')*"\n")
    io
end


"""Write telemetry information. Note: This does not escape comas!"""
function telemetry!(sp::Spacecraft, name::Symbol; entries...)
    acquire(sp, :iostream)
    if name ∉ keys(sp.system.ios)
        path = string(sp.system.home, '/', name, ".csv")
        sp.system.ios[name] = start_csv!(path, keys(entries))
    end
    release(sp, :iostream)
    time = string(sp.system.ut, ',', format_MET(sp.system.met), ',')
    entry = join(values(entries), ',')*"\n"
    write(sp.system.ios[name], time * entry)
end
