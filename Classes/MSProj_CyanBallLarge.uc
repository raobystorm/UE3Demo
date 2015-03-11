class MSProj_CyanBallLarge extends MSProj_PurpleBarrageWeak;

simulated function ProcessTouch (Actor Other, vector HitLocation, vector HitNormal)
{
	local MSPawn HitPawn;

	HitPawn = MSPawn(Other);
	if(HitPawn != none)
	{
		// If we hit a pawn and this pawn is not a player, then we do not explode
		if(MSPlayerController(HitPawn.Controller) == none) return;

		// When we hit the player, we could do some extra works here
		if ( Role == ROLE_Authority )
			MakeNoise(1.0);
		if( !bShuttingDown )
		{
			ProjectileHurtRadius(HitLocation, HitNormal);
		}
	}
	else Explode( HitLocation, HitNormal );
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=43
		CollisionHeight=43
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBallLarge'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBallLarge_Impact'
	MaxEffectDistance=4096.0

	Speed=2025
	MaxSpeed=0
	AccelRate=-6050
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=0.25
	Timer=ResetAccel

	Damage=70
	DamageRadius=0
	MomentumTransfer=50000
	CheckRadius=43

	MyDamageType=class'UTDmgType_Fire'
	LifeSpan=4.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=4.3

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}