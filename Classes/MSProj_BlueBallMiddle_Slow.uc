class MSProj_BlueBallMiddle_Slow extends MSProj_PurpleBarrageWeak;

var int FinalSpeed;

function ResetAccel()
{
	Acceleration = vect(0,0,0);
	AccelRate = 0;
	Velocity = FinalSpeed * Normal(Velocity);
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BlueBallMiddle'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BlueBallMiddle_Impact'
	MaxEffectDistance=4096.0

	Speed=2000
	MaxSpeed=0
	FinalSpeed=400
	AccelRate=0
	LocalAcceleration=(X=-4000,Y=100,Z=0)
	bBlockedByInstigator=true
	bNeedUpdateRotation=false

	TimerCount=1
	TimerDelay=0.4
	Timer=ResetAccel

	Damage=15
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=30

	MyDamageType=class'UTDmgType_Lava'
	LifeSpan=7.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.5

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}