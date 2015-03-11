class MSProj_RedBarrageSmall extends MSProj_PurpleBarrageWeak;

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_RedBarrageSmall'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_RedBarrageSmall_Impact'
	MaxEffectDistance=4096.0

	Speed=2025
	MaxSpeed=0
	AccelRate=-6050
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=0.3
	Timer=ResetAccel

	Damage=30
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=30

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=4.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.5

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}