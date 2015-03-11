class MSWeap_BossPhase1 extends MSWeapon;

var Rotator MultiProjectileRotOffset;
var Vector SpawnLocation;

var Array<Projectile> SpawnedProjectiles;
var float ShootInterval;
/*
 * Large projectile used properties
 * */
var Rotator SpawnCyanDirection;
var int SpawnCyanWave;

/*
 * Small projectiles used properties
 * */
var int SpawnSmallWaveCount;
var Rotator SpawnPurpleBaseDirection;
var Rotator SpawnYellowBaseDirection;

function SpawnSmallProjectiles()
{
	SpawnPurpleProjectile();
	SpawnYellowProjectile();

	SpawnSmallWaveCount--;
	if(SpawnSmallWaveCount > 0)
	{
		SpawnPurpleBaseDirection -= MultiProjectileRotOffset;
		SpawnYellowBaseDirection += MultiProjectileRotOffset;
		SetTimer(ShootInterval, false, 'SpawnSmallProjectiles');
	}
}

function SpawnPurpleProjectile()
{
	local int i;
	local Rotator SpawnDirection;
	local MSProj_PurpleBarrageSmall Projectile;

	SpawnDirection = SpawnPurpleBaseDirection - CurrentFireLevel * MultiProjectileRotOffset;

	for( i = 0; i < 1 + CurrentFireLevel * 2 ; i++)
	{
		Projectile = Spawn(class'MSProj_PurpleBarrageSmall',,, SpawnLocation);
		if(Projectile == none) 
		{
			`log("Projectile Spawn Failed!");
			return;
		}
		Projectile.Speed -= i * 60;
		Projectile.Init(Vector(SpawnDirection));
		SpawnedProjectiles.AddItem(Projectile);
		
		SpawnDirection += MultiProjectileRotOffset;
	}
}

function SpawnYellowProjectile()
{
	local int i;
	local Rotator SpawnDirection;
	local MSProj_YellowBarrageSmall Projectile;

	SpawnDirection = SpawnYellowBaseDirection + CurrentFireLevel * MultiProjectileRotOffset;

	for( i = 0 ; i < 1 + CurrentFireLevel * 2 ; i++)
	{
		Projectile = Spawn(class'MSProj_YellowBarrageSmall' ,,, SpawnLocation);
		if(Projectile == none )
		{
			`log("Projectile Spawn Failed!");
			return;
		}
		Projectile.Speed -= i * 60;
		Projectile.Init(Vector(SpawnDirection));
		SpawnedProjectiles.AddItem(Projectile);

		SpawnDirection -= MultiProjectileRotOffset;
	}
}

function SpawnCyanProjectiles()
{
	local MSProj_CyanBallLarge Projectile;
	local int i;

	SpawnCyanDirection = GetAdjustedAim( SpawnLocation );

	for(i = 0; i < 4 ; i++ )
	{
		Projectile = Spawn( class'MSProj_CyanBallLarge',,, SpawnLocation);
		if(Projectile == none )
		{
			`log("Projectile Spawn Failed!");
		}
		Projectile.Speed += i * 100;
		Projectile.Init(Vector(SpawnCyanDirection));
		SpawnedProjectiles.AddItem(Projectile);
	}

	SpawnCyanWave--;	

	if(SpawnCyanWave != 0) 
		SetTimer( 0.5, false, 'SpawnCyanProjectiles');
}

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local Rotator AdjustedAim, BaseAim;
	local int LineCount;
	local float HeightOffset;

	MultiProjectileRotOffset.Pitch = 0;
	MultiProjectileRotOffset.Roll = 0;

	MultiProjectileRotOffset.Yaw = DegToUnrRot * 6;

	LineCount = 16384 / MultiProjectileRotOffset.Yaw;
	
	/*HeightOffset = MSBoss.Default.CollisionCylinder.CollisionHeight - MSPlayer.default.CollisionCylinder.CollisionHeight;
	HeightOffset /= 2.0;*/
	HeightOffset = 80;

	RealStartLoc.Z -= HeightOffset;
	SpawnLocation = RealStartLoc;

	AdjustedAim = GetAdjustedAim( RealStartLoc );

	if(AdjustedAim.Pitch < 0 ) AdjustedAim.Pitch = 0;

	BaseAim = AdjustedAim;
	AdjustedAim -= 0.5 * MultiProjectileRotOffset;
	AdjustedAim.Yaw += 4096;
	SpawnPurpleBaseDirection = AdjustedAim;

	AdjustedAim = BaseAim;
	AdjustedAim += 0.5 * MultiProjectileRotOffset;
	AdjustedAim.Yaw -= 4096;
	SpawnYellowBaseDirection = AdjustedAim;

	SpawnCyanDirection = BaseAim;
	SpawnCyanWave = CurrentFireLevel * 2;

	ShootInterval = 0.1;

	SpawnSmallWaveCount = LineCount;

	SpawnSmallProjectiles();
	SpawnCyanProjectiles();

	return SpawnedProjectiles;
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

	FireInterval(0)=+4.0
	FireInterval(1)=+4.0

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
