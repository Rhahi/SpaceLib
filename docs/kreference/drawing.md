julia> show(stdout, "text/plain", names(KRPC.Interface.Drawing))
65-element Vector{Symbol}:
 :AddDirection
 :AddDirectionFromCom
 :AddLine
 :AddPolygon
 :AddText
 :Clear
 :Drawing
 :Line_Remove
 :Line_get_Color
 :Line_get_End
 :Line_get_Material
 :Line_get_ReferenceFrame
 :Line_get_Start
 :Line_get_Thickness
 :Line_get_Visible
 :Line_set_Color
 :Line_set_End
 :Line_set_Material
 :Line_set_ReferenceFrame
 :Line_set_Start
 :Line_set_Thickness
 :Line_set_Visible
 :Polygon_Remove
 :Polygon_get_Color
 :Polygon_get_Material
 :Polygon_get_ReferenceFrame
 :Polygon_get_Thickness
 :Polygon_get_Vertices
 :Polygon_get_Visible
 :Polygon_set_Color
 :Polygon_set_Material
 :Polygon_set_ReferenceFrame
 :Polygon_set_Thickness
 :Polygon_set_Vertices
 :Polygon_set_Visible
 :Text_Remove
 :Text_get_Alignment
 :Text_get_Anchor
 :Text_get_CharacterSize
 :Text_get_Color
 :Text_get_Content
 :Text_get_Font
 :Text_get_LineSpacing
 :Text_get_Material
 :Text_get_Position
 :Text_get_ReferenceFrame
 :Text_get_Rotation
 :Text_get_Size
 :Text_get_Style
 :Text_get_Visible
 :Text_set_Alignment
 :Text_set_Anchor
 :Text_set_CharacterSize
 :Text_set_Color
 :Text_set_Content
 :Text_set_Font
 :Text_set_LineSpacing
 :Text_set_Material
 :Text_set_Position
 :Text_set_ReferenceFrame
 :Text_set_Rotation
 :Text_set_Size
 :Text_set_Style
 :Text_set_Visible
 :Text_static_AvailableFonts

julia> show(stdout, "text/plain", names(KRPC.Interface.Drawing.RemoteTypes))
5-element Vector{Symbol}:
 :Drawing
 :Line
 :Polygon
 :RemoteTypes
 :Text

julia> show(stdout, "text/plain", names(KRPC.Interface.Drawing.Helpers))
45-element Vector{Symbol}:
 :AddDirection
 :AddDirectionFromCom
 :AddLine
 :AddPolygon
 :AddText
 :Alignment
 :Alignment!
 :Anchor
 :Anchor!
 :AvailableFonts
 :CharacterSize
 :CharacterSize!
 :Clear
 :Color
 :Color!
 :Content
 :Content!
 :End
 :End!
 :Font
 :Font!
 :Helpers
 :LineSpacing
 :LineSpacing!
 :Material
 :Material!
 :Position
 :Position!
 :ReferenceFrame
 :ReferenceFrame!
 :Remove
 :Rotation
 :Rotation!
 :Size
 :Size!
 :Start
 :Start!
 :Style
 :Style!
 :Thickness
 :Thickness!
 :Vertices
 :Vertices!
 :Visible
 :Visible!