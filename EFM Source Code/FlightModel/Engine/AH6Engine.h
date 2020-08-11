#pragma once

/* Start sequence based on OH-6 manual
OH-6 start sequence:
batt on (or ext for ground elec power start)
press and hold starter button
wait until N1 reaches 15%
open throttle to idle pos
release starter at 58% N1
final N1 62%

engine run up:
throttle to full open, N2 101%
*/

class AH6Engine
{
protected:

public:
		
	double throttleInput;	// Throttle input command 

	double N1_RPM;
	bool engineRunning;

	bool isStarterPressed;

	// oil pressure: 0-100 psi
	double oilPressure;
	// cockpit gauge: 300..900 range
	double engineTemperature;

	double rotorPosition; // animation position

	AH6Engine() 
		: throttleInput(0)
		, N1_RPM(0)
		, engineRunning(false)
		, isStarterPressed(false)
		, oilPressure(100)
		, engineTemperature(900)
		, rotorPosition(0)
			
	{}
	~AH6Engine() {}

	void initCold()
	{
		throttleInput = 0;
		N1_RPM = 0;
		isStarterPressed = false;
		engineRunning = false;
		rotorPosition = 0;
	}
	void initHot()
	{
		throttleInput = 1;
		N1_RPM = 100;
		isStarterPressed = false;
		engineRunning = true;
		rotorPosition = 0;
	}

	void setThrottleInput(const double value)
	{
		throttleInput = value;
		throttleInput = limit(throttleInput, 0, 1);
	}
	void setStarterButton(const float value)
	{
		if (value == 1)
		{
			isStarterPressed = true;
			return;
		}
		isStarterPressed = false;
	}

	double getCoreRelatedRPM()
	{
		return N1_RPM / 100;
	}

	void spinRotor(const double frameTime)
	{
		rotorPosition += (N1_RPM/100) * frameTime * 7.8; //470rpm=~ 7.83 rev per sec
		if (rotorPosition > 1)
		{
			rotorPosition = 0;
		}
	}

	void turnStarter(double frameTime)
	{
		N1_RPM += frameTime * 3; // will get to 15% in 5 seconds
		N1_RPM = limit(N1_RPM, 0, 19); // starter wont turn engine past 20% or so
	}
	
	void spoolUp(double frameTime)
	{
		N1_RPM += frameTime * 3.4; 
		N1_RPM = limit(N1_RPM, 0, 62);
	}

	void spoolDown(double frameTime)
	{
		N1_RPM -= frameTime * 7;
		N1_RPM = limit(N1_RPM, 0, 100);
	}

	void update(const double frameTime, const bool isFuelFlow, const bool isDCpower)
	{

		if (N1_RPM >= 58 && isFuelFlow)
		{
			engineRunning = true;
		}
		else
		{
			engineRunning = false;
		}

		if (isStarterPressed && isDCpower)
		{
			if (isFuelFlow == true && N1_RPM > 13)
			{
				spoolUp(frameTime);
			}
			else
			{
				turnStarter(frameTime);
			}
		}
		else if (N1_RPM > 58 && N1_RPM < 62 && engineRunning)
		{
			spoolUp(frameTime);
		}
		else if (engineRunning == false)
		{
			spoolDown(frameTime);
		}

		if (engineRunning && N1_RPM >= 62)
		{
			N1_RPM = (38 * throttleInput) + 62;
			N1_RPM = limit(N1_RPM, 0, 100);
		}

		spinRotor(frameTime);
	}
};
