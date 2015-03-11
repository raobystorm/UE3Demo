class MSProjectile extends UTProjectile;

var Vector OriginDirection;
var Vector LocalAcceleration;
/*
 *  Projectile Timer setup variables.
 *  In the situation, each projectile could set a couple of timers to control the their physic movement. *  
 * */
// Count of the timer we need to set-up.
var int TimerCount;
// Array of the timer functions we need to process time-related operations.
var Name Timer;
// The trigger delay of the timers
var float TimerDelay;

// This is used as the interval value of the projectiles which can split child projectiles
var float SplitInterval;
// Counting split times of this projectile
var int SplitCount;
// The list of the child projectils
var array<MSProjectile> SplitChildren;
// The classes of the split projectiles
var class<Projectile> SplitChildrenClass;

// Check if we need update projectile's rotation
// This happened when our porjectile has a tail and a rotaion rate
// Speed which makes itself spinning while flight
var bool bNeedUpdateRotation;

function Init(vector Direction)
{
	SetRotation(rotator(Direction));
	OriginDirection = Direction;

	Velocity = Speed * Direction;
	Velocity.Z += TossZ;
	if( LocalAcceleration.X == 0 && LocalAcceleration.Y == 0 && LocalAcceleration.Z == 0)
	{
		Acceleration = AccelRate * Normal(Velocity);
	}
	else
	{
		Acceleration = LocalAcceleration >> Rotation;
	}

	if(TimerCount != 0)
	{
		TimerSetup();
	}
}

// Generally timer setup loop.
function TimerSetup()
{
	local int i;

	for(i=0; i< TimerCount; i++)
	{
		SetTimer(TimerDelay , false, Timer);
	}
}

function SplitProjectile();

function ResetAccel()
{
	Acceleration = Vect(0,0,0);
	AccelRate = 0;
}

simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(bNeedUpdateRotation) SetRotation(Rotator(Velocity));
}

DefaultProperties
{
	LocalAcceleration=(X=0,Y=0,Z=0)
	bNeedUpdateRotation=false

	TimerCount=0
	TimerDelay=0.0
	Timer=none

	SplitInterval=0.0
	SplitCount=0
}
