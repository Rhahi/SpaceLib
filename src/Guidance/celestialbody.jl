module CelestialBody

import Unitful: Length, Acceleration, Pressure
import Geophysics: pressure
import Base: @kwdef
import Unitful: uconvert, ustrip
using Unitful.DefaultSymbols
import PhysicalConstants.CODATA2018: g_n

@kwdef struct Body{L<:Length, A<:Acceleration}
    radius::L
    atmosphere::L
    grav::A
    atm_pressure::Function
    atm_scale::Function
    atm_density::Function
end
Body(r, a, g, atm_source::Function, Rₛₚ) = Body(
    radius=r,
    atmosphere=a,
    grav=g,
    atm_pressure = h->atm_source(h)Pa,
    atm_scale = h->atm_source(h)/atm_source(0),
    atm_density = (h,t)->density(atm_source(h)Pa,t, Rₛₚ)
)

Earth = Body(
    6371km,
    140km,
    uconvert(m/s^2, g_n),
    x->pressure(ustrip(x)),
    287.052874J/kg/K
)

density(pressure, temperature, Rₛₚ) = pressure / Rₛₚ / temperature

end # module Body
