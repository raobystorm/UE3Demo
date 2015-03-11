class MSProj_CyanBarrageTiny extends MSProj_PurpleBarrageWeak;

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageSmall'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageSmall_Impact'
	MaxEffectDistance=4096.0

	Speed=1100
	MaxSpeed=3000
	AccelRate=800
	bBlockedByInstigator=true

	Damage=15
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=35

	MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}