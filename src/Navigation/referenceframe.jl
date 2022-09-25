module ReferenceFrame

using KRPC
using SpaceLib
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.Helpers as SCH

"""
The reference frame that is fixed relative to the vessel, and orientated with the surface of the body being orbited. The origin is at
the center of mass of the vessel.The axes rotate with the north and up directions on the surface of the body.The x-axis points in the
zenith direction (upwards, normal to the body being orbited, from the center of the body towards the center of mass of the vessel).The
y-axis points northwards towards the astronomical horizon (north, and tangential to the surface of the body - the direction in which a
compass would point when on the surface).The z-axis points eastwards towards the astronomical horizon (east, and tangential to the
surface of the body - east on a compass when on the surface).
"""
function SRF(sp::Spacecraft)
    SCH.SurfaceReferenceFrame(sp.ves)
end


"""
The reference frame that is fixed relative to the vessel, and orientated with the velocity vector of the vessel relative to the surface
of the body being orbited. The origin is at the center of mass of the vessel.The axes rotate with the vessel's velocity vector.The
y-axis points in the direction of the vessel's velocity vector, relative to the surface of the body being orbited.The z-axis is in the
plane of the astronomical horizon.The x-axis is orthogonal to the other two axes.
"""
function SVRF(sp::Spacecraft)
    SCH.SurfaceVelocityReferenceFrame(sp.ves)
end


"""
The reference frame that is fixed relative to this celestial body, and
orientated in a fixed direction (it does not rotate with the body). The origin
is at the center of the body.The axes do not rotate.The x-axis points in an
arbitrary direction through the equator.The y-axis points from the center of
the body towards the north pole.The z-axis points in an arbitrary direction
through the equator.
"""
function BCI(sp::Spacecraft)
    orbit = SCH.Orbit(sp.ves)
    body = SCH.Body(orbit)
    SCH.NonRotatingReferenceFrame(body)
end


"""Body centered body focused frame in current body"""
function BCBF(sp::Spacecraft)
    orbit = SCH.Orbit(sp.ves)
    body = SCH.Body(orbit)
    SCH.ReferenceFrame(body)
end


"""
The reference frame that is fixed relative to the vessel, and orientated with
the vessels orbital prograde/normal/radial directions. The origin is at the
center of mass of the vessel.The axes rotate with the orbital
prograde/normal/radial directions.The x-axis points in the orbital anti-radial
direction.The y-axis points in the orbital prograde direction.The z-axis points
in the orbital normal direction.
"""
function ORF(sp::Spacecraft)
    SCH.OrbitalReferenceFrame(sp.ves)
end


function COMF(part::SCR.Part)
    SCH.CenterOfMassReferenceFrame(part)
end

end