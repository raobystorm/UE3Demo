class MSWeap_BossPhase5 extends MSWeapon;

// here is a cool down time counter 
var Array<Projectile> SpawnedExplosionSpheres;

// Spin spawn sphere properties below
var bool IsSpawnSphereCoolDown;
var float SpawnSphereCoolDown;

var bool IsExplosionSphereCoolDown;
var float ExplosionSphereCoolDown;

var bool IsRandomExplosionCoolDown;
var int RandomExplosionCount;
var float RandomExplosionCoolDown;
var float RandomRadius;

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local int i, SpawnSphereCount;
	local Rotator AdjustedAim, BaseAim, SpawnOffset;
	local MSProj_SpawnSphere2_Spin SpawnSphere;
	local MSProj_ExplosionSphere ExplosionSphere;
	local MSProj_RandomExplosionSphere RandomExplosionSphere;
	local Vector HitLoc, HitNormal, RandomLoc;
	local TraceHitInfo HitInfo;
	local MSPawn HitPawn;
	local float HeightOffset;
	
	HeightOffset = 80.0;
	RealStartLoc.Z -= HeightOffset;

	AdjustedAim = GetAdjustedAim(RealStartLoc);
	if(AdjustedAim.Pitch < 0 ) AdjustedAim.Pitch = 0;

	BaseAim = AdjustedAim;
	
	// Spawn the sphere projectile below
	if(!IsSpawnSphereCoolDown)
	{

		SpawnSphereCount = (CurrentFireLevel - 1) * 3;

		SpawnOffset.Pitch = 0;
		SpawnOffset.Roll = 0;
		SpawnOffset.Yaw = 65535 / SpawnSphereCount;

		AdjustedAim -= 0.5 * SpawnOffset;

		for(i = 0; i < SpawnSphereCount; i++ )
		{
			SpawnSphere = Spawn(class'MSProj_SpawnSphere2_Spin' ,,, RealStartLoc);
			
			SpawnSphere.FireLevel = CurrentFireLevel;
			SpawnSphere.SplitRot = AdjustedAim;
			
			SpawnSphere.Init(Vector(AdjustedAim));

			AdjustedAim += SpawnOffset;
		}

		IsSpawnSphereCoolDown = true;
		SpawnSphereCoolDown = SpawnSphere.LifeSpan;
		SetTimer(SpawnSphereCoolDown, false, 'SphereCoolDownComplete');
	}

	if(!IsExplosionSphereCoolDown)
	{
		AdjustedAim = BaseAim;

		HitPawn = MSPawn( Trace( HitLoc, HitNormal, Normal(Vector(AdjustedAim)) * 65535 + RealStartLoc, RealStartLoc, true , , HitInfo));
		if(HitPawn != none )
		{
			ExplosionSphere = Spawn(class'MSProj_ExplosionSphere' ,,, RealStartLoc);
			ExplosionSphere.SeekTarget = HitPawn;
			ExplosionSphere.TimerDelay = (VSize(HitLoc - RealStartLoc) / ExplosionSphere.Speed) + 0.3;

			ExplosionSphere.Init(Vector(AdjustedAim));

			IsExplosionSphereCoolDown = true;
			SetTimer(ExplosionSphereCoolDown, false, 'ExplosionSphereCoolDownComplete');
		}
	}

	if(!IsRandomExplosionCoolDown)
	{
		AdjustedAim = BaseAim;

		AdjustedAim.Pitch = 0;
		AdjustedAim.Roll = 0;
		AdjustedAim.Yaw = DegToUnrRot * Rand(360);

		RandomLoc = FRand() * RandomRadius * Normal(Vector(AdjustedAim)) + RealStartLoc + Normal(Vector(AdjustedAim)) * 425;
		RandomExplosionSphere = Spawn(class'MSProj_RandomExplosionSphere' ,,, RandomLoc);
		RandomExplosionSphere.TimerDelay += FRand();
		RandomExplosionSphere.Init(Vector(AdjustedAim));

		RandomExplosionCount--;

		if(RandomExplosionCount == 0)
		{
			IsRandomExplosionCoolDown = true;
			SetTimer(RandomExplosionCoolDown, false, 'RandomExplosionCoolDownComplete');
		}
	}

	return SpawnedExplosionSpheres;
}

function SphereCoolDownComplete()
{
	IsSpawnSphereCoolDown = false;
}

function ExplosionSphereCoolDownComplete()
{
	IsExplosionSphereCoolDown = false;
}

function RandomExplosionCoolDownComplete()
{
	IsRandomExplosionCoolDown = false;
	RandomExplosionCount = CurrentFireLevel * 2;
}

defaultproperties
{
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	AttachmentClass=class'MSWeaponAttachment_EnemyWeaponTransparent'

    WeaponFireTypes(0)=EWFT_MultiProjectile
	WeaponFireTypes(1)=EWFT_MultiProjectile
	
    WeaponProjectiles(0)=class'MSProj_PurpleBarrageSmall'
	WeaponProjectiles(1)=class'MSProj_YellowBarrageSmall'

	WeaponEquipSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_RaiseCue'
	WeaponPutDownSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_LowerCue'
	WeaponFireSnd(0)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	WeaponFireSnd(1)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	FireInterval(0)=+0.5
	FireInterval(1)=+0.5

	MaxDesireability=0.65
	AIRating=0.65
	CurrentRating=0.65
	bInstantHit=false
	bSplashJump=false
	bRecommendSplashDamage=false
	bSniping=true
	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=0

	ShotCost(0)=0
	ShotCost(1)=0

	IsSpawnSphereCoolDown=false
	SpawnSphereCoolDown=10.0

	IsExplosionSphereCoolDown=false
	ExplosionSphereCoolDown=1.5

	IsRandomExplosionCoolDown=false
	RandomExplosionCoolDown=6.0
	RandomRadius=700.0
	RandomExplosionCount=4

	FireOffset=(X=60,Y=15,Z=-7)

	AmmoCount=20
	LockerAmmoCount=20
	MaxAmmoCount=40

	IconCoordinates=(U=728,V=382,UL=162,VL=45)

	WeaponColor=(R=160,G=180,B=255,A=255)

	InventoryGroup=4
	GroupWeight=0.5

	IconX=400
	IconY=129
	IconWidth=22
	IconHeight=48

	CurrentFireLevel=2

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
   
}
