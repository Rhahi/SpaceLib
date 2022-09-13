julia> show(stdout, "text/plain", names(KRPC.Interface.DockingCamera))
5-element Vector{Symbol}:
 :Camera
 :Camera_get_Image
 :Camera_get_Part
 :DockingCamera
 :get_Available

julia> show(stdout, "text/plain", names(KRPC.Interface.DockingCamera.RemoteTypes))
3-element Vector{Symbol}:
 :Camera
 :DockingCamera
 :RemoteTypes

julia> show(stdout, "text/plain", names(KRPC.Interface.DockingCamera.Helpers))
5-element Vector{Symbol}:
 :Available
 :Camera
 :Helpers
 :Image
 :Part