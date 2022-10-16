function get_flight(sp::Spacecraft, ref::SCR.ReferenceFrame)
    SCH.Flight(sp.ves, ref)
end
