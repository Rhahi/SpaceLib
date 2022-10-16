mutable struct System
    home::String
    lock::Dict{Symbol, Base.Semaphore}
    ios::Dict{Symbol, IOStream}
    met::Float64
    ut::Float64
    clocks::Vector{Channel{Float64}}


    function System(home::String="")
        lock = Dict{Symbol, Base.Semaphore}(
            :stream => Base.Semaphore(1),
            :semaphore => Base.Semaphore(1),
            :iostream => Base.Semaphore(1),
            )
        ios = Dict{Symbol, IOStream}()
        clocks = Vector{Channel{Float64}}()
        new(home, lock, ios, 0., 0., clocks)
    end
end


struct Spacecraft
    conn::KRPC.KRPCConnection
    sc::SCR.SpaceCenter
    ves::SCR.Vessel
    parts::Dict{Symbol, SCR.Part}
    events::Dict{Symbol, Condition}
    system::System

    function Spacecraft(conn::KRPC.KRPCConnection,
                        sc::SCR.SpaceCenter,
                        ves::SCR.Vessel,
                        system::System)
        parts = Dict{Symbol, SCR.Part}()
        events = Dict{Symbol, Condition}(
            :lanunch => Condition(),
            :abort => Condition(),
            )
        new(conn, sc, ves, parts, events, system)
    end
end


function release(sp::Spacecraft, lock::Symbol)
    Base.release(sp.system.lock[lock])
end


function acquire(sp::Spacecraft, lock::Symbol)
    Base.acquire(sp.system.lock[:semaphore])
    if lock ∈ keys(sp.system.lock)
        Base.acquire(sp.system.lock[lock])
    else
        sem = Base.Semaphore(1)
        sp.system.lock[lock] = sem
        Base.acquire(sem)
    end
    Base.release(sp.system.lock[:semaphore])
end
