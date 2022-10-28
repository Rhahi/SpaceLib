module Guidance

using SpaceLib
using DifferentialEquations
using StaticArrays
using LinearAlgebra
using Unitful
using Unitful.DefaultSymbols
import Unitful: Time, Length, Force, Mass, MassFlow, Velocity, Temperature, Area
import Base: @kwdef

# export modules
export CelestialBody

# export structs
export Stage, Rocket, HotStageRocket

# export functions
export thrust, drag, gravity_acc

include("celestialbody.jl")
include("rockets.jl")
include("eom.jl")
# include("predict.jl")
# include("binaryApproxODE.jl")

end # module
