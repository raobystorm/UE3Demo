class MSProj_CyanBarrageSmall extends MSProj_PurpleBarrageWeak;

var int TurningCount;
var Vector FinalDirection;

function TurningDirection()
{
	Acceleration *= -1.0;
	TurningCount--;
	if(TurningCount > 0)
	{
		SetTimer(0.65, false, 'TurningDirection');
	}
	else
	{
		SetTimer(0.05, false, 'SetFinalFlight');
	}
}

function SetFinalFlight()
{
	Velocity = 1100 * FinalDirection;
	Acceleration = Velocity * 1;
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageSmall'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageSmall_Impact'
	MaxEffectDistance=4096.0

	Speed=0
	MaxSpeed=0
	LocalAcceleration=(X=6000,Y=0,Z=0)
	bBlockedByInstigator=true

	bNeedUpdateRotation=true
	TimerCount=1
	TimerDelay=0.25
	Timer=TurningDirection

	TurningCount=2

	Damage=15
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=30

	MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=3
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.0

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}