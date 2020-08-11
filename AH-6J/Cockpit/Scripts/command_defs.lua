local function counter()
	count = count + 1
	return count
end

count = 10000

Keys =
{
	BattSwitch	 	 = counter(),
	ExtPwrSwitch	 = counter(),
	ThrottleCutoff 	 = counter(),
	ThrottleIncrease = counter(),
	ThrottleDecrease = counter(),
	ThrottleStop 	 = counter(),
	LandingLight	 = counter(),
	
	TriggerFireOn	= counter(),
	TriggerFireOff 	= counter(),
	PickleOn		= counter(),
	PickleOff		= counter(),
	MasterArm		= counter(),
	
	showControlInd = counter(),
}

count = 3200
device_commands = { -- commands for lua

	AuxPowerSw  	= counter();
	
	FuelShutoffSw	= counter();
	FuelPumpSw 		= counter();
	
	MasterArm		= counter();
	SalvoSw			= counter();
	JettSw			= counter();
	JettSwCover		= counter();
	RocketSelector	= counter();
	GunSelector		= counter();
	
	PositionLights	= counter();
	CovertLight		= counter();
	AntiCollision	= counter();
	LandingLightSw	= counter();
	
	RWRpower		= counter();
	RWRBrightness	= counter();
	
	AltimeterSet	= counter();
	ADIadjust		= counter();
	LOset			= counter();
	HIset			= counter();
}

EFM_commands = 	-- commands for use in EFM
{
	starterButton 		= 3000,
	throttleIdleCutoff	= 3001,
	throttle			= 3002,
	batterySwitch 		= 3003,
	generatorSwitch 	= 3004,
	inverterSwitch 		= 3005,
	throttleAxis		= 3006,
	trimUp				= 3007,
	trimDown			= 3008,
	trimLeft			= 3009,
	trimRight			= 3010,
}


