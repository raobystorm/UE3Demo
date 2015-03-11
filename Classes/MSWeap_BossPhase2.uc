class MSWeap_BossPhase2 extends MSWeapon;

// here is a cool down time counter 
var bool IsSphereCoolDown;
var int SpawnSphereCount;
var float SpawnCoolDown;
var Array<Projectile> SpawnedProjectiles;

// Outter ring of barrage variables
var bool IsCircleCoolDown;
var float OutterCircleCoolDown;
var int CircleCount;

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local int i, CountPerCircle, RedSpawnCount;
	local Rotator AdjustedAim, BaseAim, SpawnOffset;
	local Vector HitLocation, HitNormal, FireDir;
	local MSProj_SpawnSphere SpawnSphere;
	local MSProj_BlueBallMiddle SpawnedBlueBall;
	local MSProj_RedBallMiddle SpawnedRedBall;
	local float HeightOffset;
	
	HeightOffset = 80.0;
	RealStartLoc.Z -= HeightOffset;

	AdjustedAim = GetAdjustedAim(RealStartLoc);
	if(AdjustedAim.Pitch < 0 ) AdjustedAim.Pitch = 0;
	BaseAim = AdjustedAim;
	
	// Spawn the sphere projectile below
	if(!IsSphereCoolDown)
	{
		FireDir = Vector(AdjustedAim);
		Trace(HitLocation, HitNormal, RealStartLoc + 8192 * FireDir, RealStartLoc, true);

		SpawnSphereCount = CurrentFireLevel * 2;

		SpawnOffset.Pitch = 0;
		SpawnOffset.Roll = 0;
		SpawnOffset.Yaw = 65535 / SpawnSphereCount;

		AdjustedAim -= 0.5 * SpawnOffset;

		for(i = 0; i < SpawnSphereCount; i++ )
		{
			SpawnSphere = Spawn(class'MSProj_SpawnSphere' ,,, RealStartLoc);
			SpawnSphere.SpawnAimLoc = HitLocation;
			
			SpawnSphere.FireLevel = CurrentFireLevel;
			
			SpawnSphere.Init(Vector(AdjustedAim));

			AdjustedAim += SpawnOffset;

			SpawnedProjectiles.AddItem(SpawnSphere);
		}

		IsSphereCoolDown = true;
		SpawnCoolDown = SpawnSphere.LifeSpan;
		SetTimer(SpawnCoolDown, false, 'SphereCoolDownComplete');
	}

	if(!IsCircleCoolDown)
	{
		AdjustedAim = BaseAim;

		SpawnOffset.Pitch = 0;
		SpawnOffset.Roll = 0;
		SpawnOffset.Yaw = DegToUnrRot *(  10 +( CurrentFireLevel - 1 ) * 3);

		CountPerCircle = 65535 / SpawnOffset.Yaw;

		AdjustedAim -= SpawnOffset * 0.5;

		for( i = 0 ; i < CountPerCircle; i++)
		{
			SpawnedBlueBall = Spawn(class'MSProj_BlueBallMiddle' ,,, RealStartLoc);
			SpawnedBlueBall.Init(Vector(AdjustedAim));
			AdjustedAim += SpawnOffset;
		}

		CircleCount--;
		if(CircleCount == 0)
		{
			IsCircleCoolDown = true;
			SetTimer(OutterCircleCoolDown, false, 'CircleCoolDownComplete');
		}
	}
	
	AdjustedAim = BaseAim;

	SpawnOffset.Pitch = 0;
	SpawnOffset.Roll = 0;
	SpawnOffset.Yaw = DegToUnrRot * 7;

	RedSpawnCount = 2 * ( 2 + CurrentFireLevel);

	AdjustedAim -= (CurrentFireLevel + 0.5) * SpawnOffset;
	
	for( i = 0; i < RedSpawnCount; i++)
	{
		SpawnedRedBall = Spawn(class'MSProj_RedBallMiddle' ,,, RealStartLoc);
		SpawnedRedBall.Init(Vector(AdjustedAim));
		AdjustedAim += SpawnOffset;
	}

	return SpawnedProjectiles;
}

function SphereCoolDownComplete()
{
	IsSphereCoolDown = false;
}

function CircleCoolDownComplete()
{
	IsCircleCoolDown = false;
	CircleCount = 1 + CurrentFireLevel;
}

defaultproperties
{
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	AttachmentClass=class'MSWeaponAttachment_EnemyWeaponCyan'

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

	SpawnCoolDown=10.0
	IsSphereCoolDown=false

	IsCircleCoolDown=false
	CircleCount=3
	OutterCircleCoolDown=3.0

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
