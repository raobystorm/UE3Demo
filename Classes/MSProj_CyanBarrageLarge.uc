class MSProj_CyanBarrageLarge extends MSProj_PurpleBarrageWeak;

function SplitProjectile()
{
	// The Rotation offset of child projectile with each other
	local Rotator ChildRotationOffset, SplitRotator;
	local MSProjectile SplitProjectile;
	local int i, SplitChildrenCount;

	SplitRotator = Rotator( -1 * Normal(Velocity));

	ChildRotationOffset.Pitch = 0;
	ChildRotationOffset.Roll = 0;
	ChildRotationOffset.Yaw = DegToUnrRot * 15;

	SplitChildrenCount = 65535 / ChildRotationOffset.Yaw;

	for(i=0; i < SplitChildrenCount; i++)
	{
		SplitProjectile = MSProjectile(Spawn(SplitChildrenClass, , , Location));
		if(SplitProjectile != none)
		{
			SplitProjectile.Init(Vector(SplitRotator));
			SplitChildren.AddItem(SplitProjectile);
		}
		
		SplitRotator += ChildRotationOffset;
	}
}

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
		CollisionRadius=50
		CollisionHeight=50
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageLarge'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_CyanBarrageLarge_Impact'
	MaxEffectDistance=4096.0

	Speed=700
	MaxSpeed=700
	AccelRate=0
	bBlockedByInstigator=true

	bNeedUpdateRotation=true

	BaseTrackingStrength=5.0
	HomingTrackingStrength=32.0

	SplitInterval=0
	SplitCount=1
	SplitChildrenClass=class'MSProj_CyanBarrageTiny'

	Damage=80
	DamageRadius=50
	MomentumTransfer=50000
	CheckRadius=50

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=5.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=3

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}