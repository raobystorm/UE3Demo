class MSProj_GreenBarrageSmall_Slow extends MSProj_PurpleBarrageWeak;

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase3_Green'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase3_Green_Impact'
	MaxEffectDistance=4096.0

	Speed=300
	MaxSpeed=1000
	AccelRate=0
	LocalAcceleration=(X=0,Y=0,Z=0)
	bBlockedByInstigator=true

	TimerCount=0
	TimerDelay=0.0

	Damage=15
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=30

	MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=1.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.5

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}