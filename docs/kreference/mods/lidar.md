julia> show(stdout, "text/plain", names(KRPC.Interface.LiDAR))
5-element Vector{Symbol}:
 :Laser
 :Laser_get_Cloud
 :Laser_get_Part
 :LiDAR
 :get_Available

julia> show(stdout, "text/plain", names(KRPC.Interface.LiDAR.RemoteTypes))
3-element Vector{Symbol}:
 :Laser
 :LiDAR
 :RemoteTypes

julia> show(stdout, "text/plain", names(KRPC.Interface.LiDAR.Helpers))
5-element Vector{Symbol}:
 :Available
 :Cloud
 :Helpers
 :Laser
 :Part