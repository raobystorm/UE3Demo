/*
 * This purplr barrage is the basic barrage of enemies
 * This barrage won't do any damage to the bots
 *  
 * */
class MSProj_PurpleBarrageWeak extends MSProjectile;

var vector ColorLevel;
var vector ExplosionColor;

simulated function ProcessTouch (Actor Other, vector HitLocation, vector HitNormal)
{
	local MSPawn HitPawn;

	HitPawn = MSPawn(Other);
	if(HitPawn != none)
	{
		// If we hit a pawn and this pawn is not a player, then we do nothing
		if(MSPlayerController(HitPawn.Controller) == none) return;

		// When we hit the player, we could do some extra works here
	}

	Super.ProcessTouch(Other, HitLocation, HitNormal);
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.P_WP_ShockRifle_Ball'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.P_WP_ShockRifle_Ball_Impact'
	MaxEffectDistance=4096.0

	Speed=450
	MaxSpeed=450
	bBlockedByInstigator=true

	Damage=45
	DamageRadius=0
	MomentumTransfer=35000
	CheckRadius=30

	MyDamageType=class'UTDmgType_ShockBall'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=0.8

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}