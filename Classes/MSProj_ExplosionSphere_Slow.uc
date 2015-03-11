class MSProj_ExplosionSphere_Slow extends MSProj_PurpleBarrageWeak;

var int FireLevel;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
	if ( !bShuttingDown )
	{
		ProjectileHurtRadius(HitLocation, HitNormal );
	}
	SplitProjectile();

	SpawnExplosionEffects(HitLocation, HitNormal);

	ShutDown();
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=140
		CollisionHeight=50
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_ExplosionSphere'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_ExplosionSphere_Slow_Impact'
	MaxEffectDistance=4096.0

	Speed=900
	MaxSpeed=900
	AccelRate=0
	bBlockedByInstigator=true

	bNeedUpdateRotation=false

	FireLevel=1

	TimerCount=0
	TimerDelay=0.0

	SplitInterval=0
	SplitCount=0

	Damage=100
	DamageRadius=140
	MomentumTransfer=130000
	CheckRadius=140

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=4.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=2

	ExplosionSound=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactExplode_Cue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}