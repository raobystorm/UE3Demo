class MSProj_ExplosionSphere extends MSProj_PurpleBarrageWeak;

var int FireLevel;
var Vector SmallLocalSpawnOffset;
var MSPawn AimTarget;

function SplitProjectile()
{
	// The Rotation offset of child projectile with each other
	local Rotator SplitRotOffset, SplitRotation, SmallSplitRotOffset;
	local MSProj_OrangeBall_Slow OrangeProj;
	local Vector SmallSpawnOffset;
	local MSProj_GreenBallLarge_Slow GreenProj;
	local MSProj_GreenBarrageSmall_Slow GreenSmallProj;
	local MSProj_OrangeBarrageSmall_Slow OrangeSmallProj;
	local int i, j, SplitCountPerCircle;

	SplitRotation = Rotator( Normal(Velocity));

	SplitCountPerCircle = 8;

	SplitRotOffset.Pitch = 0;
	SplitRotOffset.Roll = 0;
	SplitRotOffset.Yaw = 65535 / SplitCountPerCircle;

	SmallSplitRotOffset.Pitch = 0;
	SmallSplitRotOffset.Roll = 0;
	SmallSplitRotOffset.Yaw = 3 * DegToUnrRot;

	for(i = 0; i < FireLevel; i++)
	{
		for(j = 0; j < SplitCountPerCircle / 2; j++)
		{
			GreenProj = Spawn(class'MSProj_GreenBallLarge_Slow' ,,, Location);
			GreenProj.Init(Vector(SplitRotation));
			
			GreenSmallProj = Spawn(class'MSProj_GreenBarrageSmall_Slow' ,,, Location);
			GreenSmallProj.LifeSpan = 1.5;
			GreenSmallProj.Init(Vector(SplitRotation));

			SplitRotation -= SmallSplitRotOffset;
			SmallSpawnOffset = SmallLocalSpawnOffset >> SplitRotation;
			GreenSmallProj = Spawn(class'MSProj_GreenBarrageSmall_Slow' ,,, Location - SmallSpawnOffset);
			GreenSmallProj.Speed -= 50;
			GreenSmallProj.LifeSpan = 1.5;
			GreenSmallProj.Init(Vector(SplitRotation));

			SplitRotation += SmallSplitRotOffset * 2;
			SmallSpawnOffset = SmallLocalSpawnOffset >> SplitRotation;
			GreenSmallProj = Spawn(class'MSProj_GreenBarrageSmall_Slow' ,,, Location + SmallSpawnOffset);
			GreenSmallProj.LifeSpan = 1.5;
			GreenSmallProj.Speed -= 50;
			GreenSmallProj.Init(Vector(SplitRotation));

			SplitRotation -= SmallSplitRotOffset;
			SplitRotation += 2 * SplitRotOffset;
		}
		SplitRotation -= SplitRotOffset;
		for(j = 0; j < SplitCountPerCircle / 2; j++)
		{
			OrangeProj = Spawn(class'MSProj_OrangeBall_Slow' ,,, Location );
			OrangeProj.Init(Vector(SplitRotation));

			OrangeSmallProj = Spawn(class'MSProj_OrangeBarrageSmall_Slow' ,,, Location);
			OrangeSmallProj.LifeSpan = 1.5;
			OrangeSmallProj.Init(Vector(SplitRotation));

			SplitRotation -= SmallSplitRotOffset;
			SmallSpawnOffset = SmallLocalSpawnOffset >> SplitRotation;
			OrangeSmallProj = Spawn(class'MSProj_OrangeBarrageSmall_Slow' ,,, Location - SmallSpawnOffset);
			OrangeSmallProj.LifeSpan = 1.5;
			OrangeSmallProj.Speed -= 50;
			OrangeSmallProj.Init(Vector(SplitRotation));

			SplitRotation += SmallSplitRotOffset * 2;
			SmallSpawnOffset = SmallLocalSpawnOffset >> SplitRotation;
			OrangeSmallProj.LifeSpan = 1.5;
			OrangeSmallProj.Speed -= 50;
			OrangeSmallProj.Init(Vector(SplitRotation));

			SplitRotation -= SmallSplitRotOffset;
			SplitRotation += 2 * SplitRotOffset;
		}
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
		CollisionRadius=50
		CollisionHeight=50
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_ExplosionSphere_GY'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_ExplosionSphere_GY_Impact'
	MaxEffectDistance=4096.0

	Speed=2700
	MaxSpeed=2700
	AccelRate=0
	bBlockedByInstigator=true

	bNeedUpdateRotation=false

	FireLevel=1

	TimerCount=1
	TimerDelay=3.0
	Timer=BlowUp

	SplitInterval=0
	SplitCount=1

	BaseTrackingStrength=5.0
	HomingTrackingStrength=32.0

	SmallLocalSpawnOffset=(X=0,Y=50,Z=0)

	Damage=60
	DamageRadius=50
	CheckRadius=50

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1

	ExplosionSound=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactExplode_Cue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}