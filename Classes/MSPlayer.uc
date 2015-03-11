class MSPlayer extends MSPawn;

var float Stamina;
var float MaxStamina;
var float StaminaRunningDrainSpeed;
var float StaminaRecoverSpeed;
var float StaminaDrainMultiplier;

var float RunningSpeed;

var bool IsRunning;
var bool AfterRunning;

function StartRunning()
{
	IsRunning = true;
	MovementSpeedModifier = RunningSpeed;
}

function StopRunning()
{
	IsRunning = false;
	AfterRunning = true;
	MovementSpeedModifier = 1.0;
	SetTimer( 2.0, false, 'StartRecover');
}

function StartRecover()
{
	AfterRunning = false;
}

simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(IsRunning)
	{
		Stamina = FMax( 0.0, Stamina - StaminaRunningDrainSpeed * StaminaDrainMultiplier * DeltaTime);

		if(Stamina == 0.0)
		{
			StopRunning();
		}
	}
	else 
	{
		if(!AfterRunning)
		{
			Stamina = FMin(MaxStamina, Stamina + StaminaRecoverSpeed * DeltaTime);
		}
	}
}

DefaultProperties
{

	/*CurrentFirePower=200
	Health=5000
	HealthMax=5000
	SuperHealthMax=5000*/

	CurrentFirePower=0
	Health=300
	HealthMax=300
	SuperHealthMax=300

	Stamina=200.0
	MaxStamina=200.0
	StaminaRecoverSpeed=25.0 // 25.0 per sec when in 60 fps
	StaminaRunningDrainSpeed=20.0 // 20 * 60
	StaminaDrainMultiplier=1.0

	RunningSpeed=1.7

	IsRunning=false
	AfterRunning=false

	InventoryManagerClass=class'MSInventoryManager'

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0015.000000
		CollisionHeight=+0060.000000
	End Object
	CylinderComponent=CollisionCylinder
}
