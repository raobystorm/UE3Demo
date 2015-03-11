class MSProj_BlueBarrage1 extends MSProjectile;

var vector ColorLevel;
var vector ExplosionColor;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local MSPawn HitPawn;

	HitPawn = MSPawn(Other);

	if(HitPawn != none)
	{
		RadiusDamage( HitLocation, HitNormal );
	}
	else
	{
		Explode( HitLocation, HitNormal );
	}
}

simulated function RadiusDamage(vector HitLocation, vector HitNormal)
{
	if (Damage>0 && DamageRadius>0)
	{
		if ( Role == ROLE_Authority )
			MakeNoise(1.0);
		if ( !bShuttingDown )
		{
			ProjectileHurtRadius(HitLocation, HitNormal );
		}
	}
	SpawnExplosionEffects(HitLocation, HitNormal);
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BlueBarrage1'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BlueBarrage1_Impact'
	MaxEffectDistance=4096.0

	Speed=1300
	MaxSpeed=9000
	bBlockedByInstigator=false
	bNeedUpdateRotation=true
	LocalAcceleration=(X=-1700,Y=-30,Z=0)

	Damage=25
	DamageRadius=10
	MomentumTransfer=0
	CheckRadius=75

	MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.5

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}