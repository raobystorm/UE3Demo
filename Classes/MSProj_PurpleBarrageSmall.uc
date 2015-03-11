class MSProj_PurpleBarrageSmall extends MSProj_PurpleBarrageWeak;

function ResetAccel()
{
	Acceleration = Vect(0,75,0) >> Rotation;
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase1_Purple'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase1_Purple_Impact'
	MaxEffectDistance=4096.0

	Speed=2050
	MaxSpeed=0
	LocalAcceleration=(X=-4800,Y=75,Z=0)
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=0.25
	Timer=ResetAccel

	Damage=30
	DamageRadius=0
	
	bNeedUpdateRotation=true

	MomentumTransfer=0
	CheckRadius=30

	MyDamageType=class'UTDmgType_Fire'
	LifeSpan=4.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.5

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}