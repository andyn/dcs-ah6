#pragma once

// - canopy status
// - refueling slot status
// - dragging chute status
// - tail hook support?
// - nav lights
// - formation lights
// - landing lights?
// - damage in sections? 
// - accumulated over-g stress?

class AH6Airframe
{
protected:
		
	// TODO: support for each lamp in lights?
	//bool navigationLight[10];
	//bool formationLight[8];
	//bool landingLamp[5];

	// current 3D model has three lights:
	// left, right and back (tail)
	// 0=off, 1=on
	float leftWingLamp;
	float rightWingLamp;
	float backTailLamp;

	bool navigationLights;
	bool formationLights;
	bool landingLights;
	bool strobeLights;

	// TODO:
	// damage status of section in 0.01 increments
	double elementIntegrity[336]; // TODO: check what size we would need here
	bool isImmortal; // <- ignore damage

public:
	AH6Airframe() 
		: leftWingLamp(0)
		, rightWingLamp(0)
		, backTailLamp(0)
		, navigationLights(false)
		, formationLights(false)
		, landingLights(false)
		, strobeLights(false)
		, isImmortal(false)
	{
		// TODO: check values, size (how many we need)
		// is zero "no fault" or "fully broken"? 
		::memset(elementIntegrity, 0, 336*sizeof(double));
	}
	~AH6Airframe() {}


	float isNavigationLight() const
	{
		return (navigationLights == true) ? 1.0f : 0.0f;
	}
	float isFormationLight() const
	{
		return (formationLights == true) ? 1.0f : 0.0f;
	}
	float isLandingLight() const
	{
		return (landingLights == true) ? 1.0f : 0.0f;
	}
	float isStrobeLight() const
	{
		return (strobeLights == true) ? 1.0f : 0.0f;
	}
	// current 3D model has three lights:
	// left, right and back (tail)
	float getLeftLight() const
	{
		return leftWingLamp;
	}
	float getRightLight() const
	{
		return rightWingLamp;
	}
	float getBackLight() const
	{
		return backTailLamp;
	}


	void onAirframeDamage(int Element, double element_integrity_factor)
	{
		// TODO: check what kind of amount of elements we would need here
		if (Element >= 0 && Element < 336)
		{
			elementIntegrity[Element] = element_integrity_factor;
		}
	}

	void onRepair()
	{
		// TODO: check values, size (how many we need)
		// is zero "no fault" or "fully broken"? 
		::memset(elementIntegrity, 0, 336*sizeof(double));
	}

	bool isRepairNeeded() const
	{
		// TODO: check values, size (how many we need)
		// is zero "no fault" or "fully broken"? 
		for (int i = 0; i < 336; i++)
		{
			if (elementIntegrity[i] > 0)
			{
				return true;
			}
		}
		return false;
	}

	void setImmortal(bool value)
	{
		isImmortal = value;
	}


	void updateFrame(const double frameTime)
	{
		// TODO: some light switching logic on/off?

		
	}
};
