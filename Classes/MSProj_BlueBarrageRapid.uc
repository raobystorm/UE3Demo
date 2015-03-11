class MSProj_BlueBarrageRapid extends MSProj_PurpleBarrageWeak;

DefaultProperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase2_Blue'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase2_Blue_Impact'
	MaxEffectDistance=4096.0

	Speed=3000
	MaxSpeed=3000
	bBlockedByInstigator=true

	Damage=20
	DamageRadius=0
	MomentumTransfer=30000
	CheckRadius=30

	bNeedUpdateRotation=true

	MyDamageType=class'UTDmgType_ShockBall'

	bCollideWorld=true
	DrawScale=1

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}
