"Convert vector to tuple"
V2T(vec::AbstractVector) = tuple(vec...)
V2T(tup::Tuple) = tup

"Convert tuple to vector"
T2V(tup::Tuple) = [tup...]
T2V(vec::AbstractVector) = vec

"Ensure Float32"
F32(value::Float32) = value
F32(value::Real) = convert(Float32, value)

"Ensure Float64"
F64(value::Float64) = value
F64(value::Real) = convert(Float64, value)

"Ensure Int32"
I32(value::Int32) = value
I32(value::Integer) = convert(Int32, value)
I32(value::AbstractFloat) = convert(Int32, round(value))

"Ensure Int64"
I64(value::Int64) = value
I64(value::Integer) = convert(Int64, value)
I64(value::AbstractFloat) = convert(Int64, round(value))

"Ensure UInt32"
UI32(value::UInt32) = value
UI32(value::Integer) = convert(UInt32, value)
UI32(value::AbstractFloat) = convert(UInt32, round(value))
