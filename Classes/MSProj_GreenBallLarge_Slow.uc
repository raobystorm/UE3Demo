class MSProj_GreenBallLarge_Slow extends MSProj_PurpleBarrageWeak;

var Vector LocalSpawnOffset;

function SplitProjectile()
{
	// The Rotation offset of child projectile with each other
	local Rotator SplitRotOffset, SplitRotation;
	local MSProjectile SplitProjectile;
	local Vector SpawnOffset;
	local int i, SplitChildrenCount;

	SplitRotation = Rotator( Normal(Velocity));

	SplitRotOffset.Pitch = 0;
	SplitRotOffset.Roll = 0;
	SplitRotOffset.Yaw = DegToUnrRot * 7;

	SplitChildrenCount = 7;

	SplitProjectile = MSProjectile(Spawn(SplitChildrenClass ,,, Location));
	SplitProjectile.Init(Vector(SplitRotation));

	for(i=1; i <= (SplitChildrenCount-1) / 2; i++)
	{
		SplitRotation -= i * SplitRotOffset;
		SpawnOffset = LocalSpawnOffset >> SplitRotation;
		SplitProjectile = MSProjectile(Spawn(SplitChildrenClass ,,, Location - SpawnOffset));
		if(SplitProjectile != none)
		{
			SplitProjectile.Speed -= 50 * i;
			SplitProjectile.Init(Vector(SplitRotation));
		}

		SplitRotation += 2 * i * SplitRotOffset;
		SpawnOffset = LocalSpawnOffset >> SplitRotation;
		SplitProjectile = MSProjectile(Spawn(SplitChildrenClass ,,, Location + SpawnOffset));
		if(SplitProjectile != none)
		{
			SplitProjectile.Speed -= 50 * i;
			SplitProjectile.Init(Vector(SplitRotation));
		}
		SplitRotation -= i * SplitRotOffset;
	}
}

function BlowUp()
{
	Explode(Location, -1 * Normal(Velocity));
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
		CollisionRadius=35
		CollisionHeight=35
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_GreenBallMiddle'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_GreenBallLarge_Slow_Impact'
	MaxEffectDistance=4096.0

	Speed=300
	MaxSpeed=300
	AccelRate=0
	bBlockedByInstigator=true

	bNeedUpdateRotation=false

	LocalSpawnOffset=(X=0,Y=50,Z=0)

	TimerCount=1
	TimerDelay=0.5
	Timer=BlowUp

	SplitInterval=0
	SplitCount=1
	SplitChildrenClass=class'MSProj_GreenBarrageSmall_Slow'

	Damage=60
	DamageRadius=35
	MomentumTransfer=0
	CheckRadius=35

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=1.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=3

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}