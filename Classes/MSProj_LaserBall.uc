
class MSProj_LaserBall extends MSProjectile;

var vector ColorLevel;
var vector ExplosionColor;


simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local MSPawn HitPawn;
	local MSPlayerController Controller;

	HitPawn = MSPawn(Other);

	if(HitPawn != none)
	{
		Controller = MSPlayerController(HitPawn.Controller);
		if(Controller != none ) return;

		Explode( HitLocation, HitNormal );
	}
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.P_WP_LaserGun_Projectile'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.P_WP_LaserGun_Impact'
	MaxEffectDistance=4096.0

	Speed=1100
	MaxSpeed=3000
	AccelRate=800
	bBlockedByInstigator=true

	Damage=10
	DamageRadius=25
	MomentumTransfer=0
	CheckRadius=75

	MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.7

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}