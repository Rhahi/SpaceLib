julia> show(stdout, "text/plain", names(KRPC.Interface.KerbalAlarmClock))
32-element Vector{Symbol}:
 :AlarmWithName
 :Alarm_Remove
 :Alarm_get_Action
 :Alarm_get_ID
 :Alarm_get_Margin
 :Alarm_get_Name
 :Alarm_get_Notes
 :Alarm_get_Remaining
 :Alarm_get_Repeat
 :Alarm_get_RepeatPeriod
 :Alarm_get_Time
 :Alarm_get_Type
 :Alarm_get_Vessel
 :Alarm_get_XferOriginBody
 :Alarm_get_XferTargetBody
 :Alarm_set_Action
 :Alarm_set_Margin
 :Alarm_set_Name
 :Alarm_set_Notes
 :Alarm_set_Repeat
 :Alarm_set_RepeatPeriod
 :Alarm_set_Time
 :Alarm_set_Vessel
 :Alarm_set_XferOriginBody
 :Alarm_set_XferTargetBody
 :AlarmsWithType
 :CreateAlarm
 :EAlarmAction
 :EAlarmType
 :KerbalAlarmClock
 :get_Alarms
 :get_Available

julia> show(stdout, "text/plain", names(KRPC.Interface.KerbalAlarmClock.RemoteTypes))
3-element Vector{Symbol}:
 :Alarm
 :KerbalAlarmClock
 :RemoteTypes

julia> show(stdout, "text/plain", names(KRPC.Interface.KerbalAlarmClock.Helpers))
30-element Vector{Symbol}:
 :Action
 :Action!
 :AlarmWithName
 :Alarms
 :AlarmsWithType
 :Available
 :CreateAlarm
 :Helpers
 :ID
 :Margin
 :Margin!
 :Name
 :Name!
 :Notes
 :Notes!
 :Remaining
 :Remove
 :Repeat
 :Repeat!
 :RepeatPeriod
 :RepeatPeriod!
 :Time
 :Time!
 :Type
 :Vessel
 :Vessel!
 :XferOriginBody
 :XferOriginBody!
 :XferTargetBody
 :XferTargetBody!