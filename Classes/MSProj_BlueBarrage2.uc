class MSProj_BlueBarrage2 extends MSPRojectile;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local MSPawn HitPawn;

	HitPawn = MSPawn(Other);

	if(HitPawn != none)
	{
		Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);
	}
	else
	{
		Explode( HitLocation, HitNormal );
	}
}

DefaultProperties
{	
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageSmall'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageSmall_Impact'

	Speed=4000
	MaxSpeed=4000
	LocalAcceleration=(X=0,Y=0,Z=0)
	DrawScale=2.3
	MomentumTransfer=0

	Damage=5
	DamageRadius=0
	CheckRadius=10
	bBlockedByInstigator=false

	MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}
