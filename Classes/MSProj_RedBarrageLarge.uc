class MSProj_RedBarrageLarge extends MSProj_PurpleBarrageWeak;

function SplitProjectile()
{
	// The Rotation offset of child projectile with each other
	local Rotator ChildRotationOffset, SplitRotator;
	local MSProjectile SplitProjectile;
	local int i;

	SplitRotator = Rotator( -1 * Normal(Velocity));

	ChildRotationOffset.Pitch = 0;
	ChildRotationOffset.Roll = 0;
	ChildRotationOffset.Yaw = DegToUnrRot * 30;

	SplitRotator -= ChildRotationOffset * 0.5;

	for(i=0; i < 2; i++)
	{
		SplitProjectile = MSProjectile(Spawn(SplitChildrenClass, , , Location));
		if(SplitProjectile != none)
		{
			SplitProjectile.LifeSpan = 2.0;
			SplitProjectile.Init(Vector(SplitRotator));
			SplitChildren.AddItem(SplitProjectile);
		}
		
		SplitRotator += ChildRotationOffset;
	}
	SplitCount--;

	if(SplitCount > 0) SetTimer(SplitInterval, false, 'SplitProjectile');
}

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
		CollisionRadius=50
		CollisionHeight=50
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_RedBarrageLarge'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_RedBarrageSmall_Impact'
	MaxEffectDistance=4096.0

	Speed=400
	MaxSpeed=400
	AccelRate=0
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=0.75
	Timer=SplitProjectile

	SplitInterval=0.4
	SplitCount=10
	SplitChildrenClass=class'MSProj_RedBarrageSmall'

	Damage=80
	DamageRadius=50
	MomentumTransfer=70000
	CheckRadius=50

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=5.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=2

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}