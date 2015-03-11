class MSProj_OrangeBarrageSmall extends MSProj_PurpleBarrageWeak;

var Rotator AimDirection;

function ResetAccel()
{
	Acceleration = vect(0,0,0);
	AccelRate = 0;
	Velocity=Vect(0,0,0);
}

function SetOff()
{
	Acceleration = Vect(3000, 100, 0) >> Rotation;
}

/*simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(bNeedUpdateRotation)	SetRotation(AimDirection);
}*/


defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase3_Orange'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase3_Orange_Impact'
	MaxEffectDistance=4096.0

	Speed=1500
	MaxSpeed=0
	AccelRate=0
	LocalAcceleration=(X=-3000,Y=0,Z=0)
	bBlockedByInstigator=true
	bNeedUpdateRotation=false

	TimerCount=1
	TimerDelay=0.5
	Timer=ResetAccel

	Damage=15
	DamageRadius=0
	MomentumTransfer=30000
	CheckRadius=30

	MyDamageType=class'UTDmgType_Lava'
	LifeSpan=10.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.5

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}