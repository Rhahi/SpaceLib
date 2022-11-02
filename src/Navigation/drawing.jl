module Drawing

using SpaceLib
import KRPC.Interface.Drawing as D
import KRPC.Interface.Drawing.RemoteTypes as DR
import KRPC.Interface.Drawing.Helpers as DH

export add_direction, update_line!, clear

const COLORS = Dict{Symbol, NTuple{3, Float64}}(
    :W       => (1., 1., 1.),
    :white   => (1., 1., 1.),
    :R       => (1., 0., 0.),
    :red     => (1., 0., 0.),
    :G       => (0., 1., 0.),
    :green   => (0., 1., 0.),
    :B       => (0., 0., 1.),
    :blue    => (0., 0., 1.),
    :C       => (0., 1., 1.),
    :cyan    => (0., 1., 1.),
    :M       => (1., 0., 1.),
    :magenta => (1., 0., 1.),
    :Y       => (1., 1., 0.),
    :yellow  => (1., 1., 0.),
    :K       => (0., 0., 0.),
    :black   => (0., 0., 0.),
    :grey    => (0.1, 0.1, 0.1),
    :off     => (0., 0., 0.),
)

"""
    add_direction(sp::Spacecraft, dir, ref; length=20, color=nothing)

Draw a line starting from spacecraft's center of mass towards a vector.
"""
function add_direction(sp::Spacecraft, dir, ref; length=20, color=nothing)
    line = DH.AddDirectionFromCom(sp.conn, V2T(dir), ref, F32(length), true)
    if !isnothing(color)
        DH.Color!(line, COLORS[color])
    end
    line
end

"""
    update_line!(line; dir=nothing, color=nothing)

Update direction or line's direction/endpoint or color.
"""
function update_line!(line; dir=nothing, color=nothing)
    !isnothing(dir) && update_line_end!(line, dir)
    !isnothing(color) && update_line_color!(line, color)
end

update_line_end!(line, dir) = DH.End!(line, V2T(dir))
update_line_color!(line, color) = DH.Color!(line, color)

"Clear all drawing items on screen."
clear(sp) = DH.Clear(sp.conn, false)

end # module