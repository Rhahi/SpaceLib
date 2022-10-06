julia> show(stdout, "text/plain", names(KRPC.Interface.MechJeb.Helpers))
360-element Vector{Symbol}:
 :APIReady
 :Abort
 :AbortTimedLaunch
 :AccKd
 :AccKd!
 :AccKi
 :AccKi!
 :AccKp
 :AccKp!
 :AdvancedDirection
 :AdvancedDirection!
 :AdvancedReference
 :AdvancedReference!
 :AirplaneAutopilot
 :AllRetracted
 :AltitudeHoldEnabled
 :AltitudeHoldEnabled!
 :AltitudeTarget
 :AltitudeTarget!
 :AntennaController
 :AoALimitFadeoutPressure
 :AoALimitFadeoutPressure!
 :AscentAutopilot
 :AscentPathClassic
 :AscentPathGT
 :AscentPathIndex
 :AscentPathIndex!
 :AscentPathPVG
 :AutoDeploy
 :AutoDeploy!
 :AutoDeployAntennas
 :AutoDeployAntennas!
 :AutoDisableSmartRCS
 :AutoDisableSmartRCS!
 :AutoPath
 :AutoPath!
 :AutoTurnEndAltitude
 :AutoTurnPercent
 :AutoTurnPercent!
 :AutoTurnSpeedFactor
 :AutoTurnSpeedFactor!
 :AutoTurnStartAltitude
 :AutoTurnStartVelocity
 :AutodeploySolarPanels
 :AutodeploySolarPanels!
 :AutopilotMode
 :AutopilotMode!
 :Autostage
 :Autostage!
 :AutostageLimit
 :AutostageLimit!
 :AutostagePostDelay
 :AutostagePostDelay!
 :AutostagePreDelay
 :AutostagePreDelay!
 :AutostagingOnce
 :AutostagingOnce!
 :Autowarp
 :Autowarp!
 :CanAlign
 :CircularizeAltitude
 :CircularizeAltitude!
 :ClampAutoStageThrustPct
 :ClampAutoStageThrustPct!
 :CorrectiveSteering
 :CorrectiveSteering!
 :CorrectiveSteeringGain
 :CorrectiveSteeringGain!
 :CourseCorrectFinalPeA
 :CourseCorrectFinalPeA!
 :DeployChutes
 :DeployChutes!
 :DeployGears
 :DeployGears!
 :DesiredApoapsis
 :DesiredApoapsis!
 :DesiredDistance
 :DesiredDistance!
 :DesiredInclination
 :DesiredInclination!
 :DesiredOrbitAltitude
 :DesiredOrbitAltitude!
 :DifferentialThrottle
 :DifferentialThrottle!
 :DifferentialThrottleStatus
 :Distance
 :DockingAutopilot
 :DockingAxis
 :ElectricThrottle
 :ElectricThrottle!
 :ElectricThrottleHi
 :ElectricThrottleHi!
 :ElectricThrottleLo
 :ElectricThrottleLo!
 :Enabled
 :Enabled!
 :ErrorMessage
 :ExecuteAllNodes
 :ExecuteOneNode
 :ExtendAll
 :FairingMaxAerothermalFlux
 :FairingMaxAerothermalFlux!
 :FairingMaxDynamicPressure
 :FairingMaxDynamicPressure!
 :FairingMinAltitude
 :FairingMinAltitude!
 :FlameoutSafetyPct
 :FlameoutSafetyPct!
 :ForcePitch
 :ForcePitch!
 :ForceRoll
 :ForceRoll!
 :ForceYaw
 :ForceYaw!
 :GetPositionTargetPosition
 :GetPositionTargetString
 :HeadingHoldEnabled
 :HeadingHoldEnabled!
 :HeadingTarget
 :HeadingTarget!
 :Helpers
 :HoldAPTime
 :HoldAPTime!
 :HotStaging
 :HotStaging!
 :HotStagingLeadTime
 :HotStagingLeadTime!
 :InterceptDistance
 :InterceptDistance!
 :InterceptInterval
 :InterceptInterval!
 :InterceptOnly
 :InterceptOnly!
 :InterfaceMode
 :InterfaceMode!
 :IntermediateAltitude
 :IntermediateAltitude!
 :KillHorizontalSpeed
 :KillHorizontalSpeed!
 :LandAtPositionTarget
 :LandUntargeted
 :LandingAutopilot
 :LaunchLANDifference
 :LaunchLANDifference!
 :LaunchMode
 :LaunchPhaseAngle
 :LaunchPhaseAngle!
 :LaunchToRendezvous
 :LaunchToTargetPlane
 :LeadTime
 :LeadTime!
 :LimitAcceleration
 :LimitAcceleration!
 :LimitAoA
 :LimitAoA!
 :LimitChutesStage
 :LimitChutesStage!
 :LimitDynamicPressure
 :LimitDynamicPressure!
 :LimitGearsStage
 :LimitGearsStage!
 :LimitThrottle
 :LimitThrottle!
 :LimitToPreventFlameout
 :LimitToPreventFlameout!
 :LimitToPreventOverheats
 :LimitToPreventOverheats!
 :LimiterMinThrottle
 :LimiterMinThrottle!
 :MakeNode
 :MakeNodes
 :ManageIntakes
 :ManageIntakes!
 :ManeuverPlanner
 :MaxAcceleration
 :MaxAcceleration!
 :MaxAoA
 :MaxAoA!
 :MaxDynamicPressure
 :MaxDynamicPressure!
 :MaxPhasingOrbits
 :MaxPhasingOrbits!
 :MaxThrottle
 :MaxThrottle!
 :MinThrottle
 :MinThrottle!
 :Mode
 :Mode!
 :MoonReturnAltitude
 :MoonReturnAltitude!
 :NewApoapsis
 :NewApoapsis!
 :NewInclination
 :NewInclination!
 :NewLAN
 :NewLAN!
 :NewPeriapsis
 :NewPeriapsis!
 :NewSemiMajorAxis
 :NewSemiMajorAxis!
 :NewSurfaceLongitude
 :NewSurfaceLongitude!
 :NodeExecutor
 :NormalTargetExists
 :OmitCoast
 :OmitCoast!
 :OperationApoapsis
 :OperationCircularize
 :OperationCourseCorrection
 :OperationEllipticize
 :OperationInclination
 :OperationInterplanetaryTransfer
 :OperationKillRelVel
 :OperationLambert
 :OperationLan
 :OperationLongitude
 :OperationMoonReturn
 :OperationPeriapsis
 :OperationPlane
 :OperationResonantOrbit
 :OperationSemiMajor
 :OperationTransfer
 :OverrideSafeDistance
 :OverrideSafeDistance!
 :OverrideTargetSize
 :OverrideTargetSize!
 :OverridenSafeDistance
 :OverridenSafeDistance!
 :OverridenTargetSize
 :OverridenTargetSize!
 :PanicSwitch
 :PeriodOffset
 :PeriodOffset!
 :PickPositionTargetOnMap
 :PitchRate
 :PitchRate!
 :PitchStartVelocity
 :PitchStartVelocity!
 :Position
 :PositionTargetExists
 :RCSController
 :RCSForRotation
 :RCSForRotation!
 :RCSThrottle
 :RCSThrottle!
 :RcsAdjustment
 :RcsAdjustment!
 :RelativePosition
 :RelativeVelocity
 :RendezvousAutopilot
 :ResonanceDenominator
 :ResonanceDenominator!
 :ResonanceNumerator
 :ResonanceNumerator!
 :RetractAll
 :RolKd
 :RolKd!
 :RolKi
 :RolKi!
 :RolKp
 :RolKp!
 :Roll
 :Roll!
 :RollHoldEnabled
 :RollHoldEnabled!
 :RollMax
 :RollMax!
 :RollTarget
 :RollTarget!
 :SafeDistance
 :SetDirectionTarget
 :SetPositionTarget
 :SimpleTransfer
 :SimpleTransfer!
 :SkipCircularization
 :SkipCircularization!
 :SmartASS
 :SmartRCS
 :SmoothThrottle
 :SmoothThrottle!
 :SolarPanelController
 :SpeedHoldEnabled
 :SpeedHoldEnabled!
 :SpeedLimit
 :SpeedLimit!
 :SpeedTarget
 :SpeedTarget!
 :StagingController
 :Status
 :StopLanding
 :SurfaceHeading
 :SurfaceHeading!
 :SurfacePitch
 :SurfacePitch!
 :SurfaceRoll
 :SurfaceRoll!
 :SurfaceVelPitch
 :SurfaceVelPitch!
 :SurfaceVelRoll
 :SurfaceVelRoll!
 :SurfaceVelYaw
 :SurfaceVelYaw!
 :TargetController
 :TargetOrbit
 :TargetSize
 :ThrottleSmoothingTime
 :ThrottleSmoothingTime!
 :ThrustController
 :TimeReference
 :TimeReference!
 :TimeSelector
 :Tolerance
 :Tolerance!
 :TouchdownSpeed
 :TouchdownSpeed!
 :TranslationSpeed
 :TranslationSpeed!
 :Translatron
 :TurnEndAltitude
 :TurnEndAltitude!
 :TurnEndAngle
 :TurnEndAngle!
 :TurnRoll
 :TurnRoll!
 :TurnShapeExponent
 :TurnShapeExponent!
 :TurnStartAltitude
 :TurnStartAltitude!
 :TurnStartPitch
 :TurnStartPitch!
 :TurnStartVelocity
 :TurnStartVelocity!
 :Update
 :UpdateDirectionTarget
 :VerKd
 :VerKd!
 :VerKi
 :VerKi!
 :VerKp
 :VerKp!
 :VertSpeedHoldEnabled
 :VertSpeedHoldEnabled!
 :VertSpeedMax
 :VertSpeedMax!
 :VertSpeedTarget
 :VertSpeedTarget!
 :VerticalRoll
 :VerticalRoll!
 :WaitForPhaseAngle
 :WaitForPhaseAngle!
 :WarpCountDown
 :WarpCountDown!
 :YawKd
 :YawKd!
 :YawKi
 :YawKi!
 :YawKp
 :YawKp!
 :YawLimit
 :YawLimit!