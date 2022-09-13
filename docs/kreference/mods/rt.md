julia> show(stdout, "text/plain", names(KRPC.Interface.RemoteTech))
25-element Vector{Symbol}:
 :Antenna
 :Antenna_get_HasConnection
 :Antenna_get_Part
 :Antenna_get_Target
 :Antenna_get_TargetBody
 :Antenna_get_TargetGroundStation
 :Antenna_get_TargetVessel
 :Antenna_set_Target
 :Antenna_set_TargetBody
 :Antenna_set_TargetGroundStation
 :Antenna_set_TargetVessel
 :Comms
 :Comms_SignalDelayToVessel
 :Comms_get_Antennas
 :Comms_get_HasConnection
 :Comms_get_HasConnectionToGroundStation
 :Comms_get_HasFlightComputer
 :Comms_get_HasLocalControl
 :Comms_get_SignalDelay
 :Comms_get_SignalDelayToGroundStation
 :Comms_get_Vessel
 :ETarget
 :RemoteTech
 :get_Available
 :get_GroundStations

julia> show(stdout, "text/plain", names(KRPC.Interface.RemoteTech.RemoteTypes))
4-element Vector{Symbol}:
 :Antenna
 :Comms
 :RemoteTech
 :RemoteTypes

julia> show(stdout, "text/plain", names(KRPC.Interface.RemoteTech.Helpers))
23-element Vector{Symbol}:
 :Antenna
 :Antennas
 :Available
 :Comms
 :GroundStations
 :HasConnection
 :HasConnectionToGroundStation
 :HasFlightComputer
 :HasLocalControl
 :Helpers
 :Part
 :SignalDelay
 :SignalDelayToGroundStation
 :SignalDelayToVessel
 :Target
 :Target!
 :TargetBody
 :TargetBody!
 :TargetGroundStation
 :TargetGroundStation!
 :TargetVessel
 :TargetVessel!
 :Vessel