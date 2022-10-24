using SpaceLib
import PhysicalConstants: g
import KRPC.Interface.SpaceCenter.RemoteTypes as SCR
import KRPC.Interface.SpaceCenter.RemoteTypes as SCH


"""DeltaV of current rocket"""
function deltav(sp::Spacecraft)
end

"""DeltaV of selected rocket stage"""
function deltav(sp::Spacecraft, stage::Int64)
    engines = SCH.Engines()
end

"""DeltaV provided by a single rocket engine"""
function deltav(sp::Spacecraft, part::SCR.Engine)
end

"""Rocket equation using exhaust velocity"""
function deltav_exhaust(vₑ::Real, m₀::Real, m₁::Real)
    Δv = vₑ*ln(m₀/m₁)
end

"""Rocket equation using specific impulse"""
function deltav_isp(Isp::Real, m₀::Real, m₁::Real)
    Δv = Isp*g*ln(m₀/m₁)
end


