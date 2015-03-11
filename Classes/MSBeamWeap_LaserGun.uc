class MSBeamWeap_LaserGun extends MSWeapon;

var Rotator MultiProjectileRotOffset, BaseAim;
var float ProjectileCirlcleFrequence;
var int ProjectilePerCircle;
var int ProjectileCircleCount;
var int CurrentProjectileWave;
var Vector ProjectileSpawnLoc;

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local Array<Projectile> SpawnedProjectiles;
	local Rotator AdjustedAim;
	local Vector StartLocOffset;
	local int i;

	MultiProjectileRotOffset.Pitch = 0;
	MultiProjectileRotOffset.Roll = 0;

	if(CurrentFireMode == 0)
	{
		MultiProjectileRotOffset.Yaw = DegToUnrRot * (5+ (CurrentFireLevel - 1) * 7) / (CurrentFireLevel * 2);   

		SpawnedProjectiles[0] = Spawn(GetProjectileClass(),,, RealStartLoc);
		if(SpawnedProjectiles[0] != none )
		{
			AdjustedAim = GetAdjustedAim( RealStartLoc );
			AdjustedAim -= MultiProjectileRotOffset*CurrentFireLevel;
			SpawnedProjectiles[0].Init(Vector(AdjustedAim));
			for(i = 1; i<= CurrentFireLevel*2; i++)
			{
				SpawnedProjectiles[i] = Spawn(GetProjectileClass(),,, RealStartLoc);
				AdjustedAim +=  MultiProjectileRotOffset;
				SpawnedProjectiles[i].Init(Vector(AdjustedAim));
			}
			return SpawnedProjectiles;
		}
	}
	else if(CurrentFireMode == 1)
	{
		BaseAim = GetAdjustedAim( RealStartLoc );
		CurrentProjectileWave = CurrentFireLevel;
		ProjectileCircleCount = CurrentFireLevel;

		MultiProjectileRotOffset.Yaw = DegToUnrRot *(  7 +( CurrentFireLevel - 1 ) * 3);

		ProjectilePerCircle = 65535 / MultiProjectileRotOffset.Yaw;
		ProjectileSpawnLoc = RealStartLoc;

		SpawnProjectileWave();

	}
	else if(CurrentFireMode == 2)
	{
		StartLocOffset = vect(0, 15, 0);

		BaseAim = GetAdjustedAim( RealStartLoc );
		AdjustedAim = BaseAim;

		StartLocOffset = StartLocOffset >> AdjustedAim;

		RealStartLoc -= StartLocOffset * (CurrentFireLevel - 0.5);

		for( i = 0 ; i < CurrentFireLevel * 2 ; i ++)
		{
			SpawnedProjectiles[i] = Spawn(GetProjectileClass(),,, RealStartLoc);
			SpawnedProjectiles[i].Init(Vector(AdjustedAim));
			RealStartLoc += StartLocOffset;
		}

		return SpawnedProjectiles;
	}
}

function SpawnProjectileWave()
{
	local Rotator AdjustedAim;
	local int j;
	local Array<Projectile> SpawnedProjectiles;

	AdjustedAim= BaseAim;
	AdjustedAim.Yaw += DegToUnrRot * ((3 - CurrentProjectileWave) * 5);

	for(j = 1; j <= ProjectilePerCircle; j++)
	{
		SpawnedProjectiles[j] = Spawn(GetProjectileClass(),,, ProjectileSpawnLoc);
		SpawnedProjectiles[j].Init(Vector(AdjustedAim));
		AdjustedAim += MultiProjectileRotOffset;
	}

	CurrentProjectileWave--;
	if(CurrentProjectileWave >= 1 )
		SetTimer(ProjectileCirlcleFrequence, false, 'SpawnProjectileWave');
}

defaultproperties
{
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	AttachmentClass=class'MSWeaponAttachment_LaserGun'

    WeaponFireTypes(0)=EWFT_MultiProjectile
	WeaponFireTypes(1)=EWFT_MultiProjectile
	WeaponFireTypes(2)=EWFT_MultiProjectile

    WeaponProjectiles(0)=class'MSProj_LaserBall'
	WeaponProjectiles(1)=class'MSProj_BlueBarrage1'
	WeaponProjectiles(2)=class'MSProj_BlueBarrage2'
   
	WeaponEquipSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_RaiseCue'
	WeaponPutDownSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_LowerCue'
	WeaponFireSnd(0)=SoundCue'Bounty.SoundCues.LaserWeaponFire_01'
	WeaponFireSnd(1)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	WeaponFireSnd(2)=SoundCue'Bounty.SoundCues.LaserWeaponFire_01'
	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	FiringStatesArray(2)=WeaponFiring

	FireInterval(0)=+0.2
	FireInterval(1)=+3.0
	FireInterval(2)=+0.15

	ProjectileCirlcleFrequence=0.5

	MaxDesireability=0.65
	AIRating=0.65
	CurrentRating=0.65
	bInstantHit=false
	bSplashJump=false
	bRecommendSplashDamage=false
	bSniping=true
	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=0
	ShouldFireOnRelease(2)=0

	ShotCost(0)=0
	ShotCost(1)=0
	ShotCost(2)=0

	Spread(2)=0.0
	
	EffectSockets(2)=MuzzleFlashSocket
	
	MinReloadPct(2)=0.6
	
	WeaponFireAnim(2)=WeaponFire
	ArmFireAnim(2)=WeaponFire

	FireOffset=(X=60,Y=15,Z=-7)

	AmmoCount=1
	LockerAmmoCount=1
	MaxAmmoCount=1

	MuzzleFlashSocket=MF
	MuzzleFlashPSCTemplate=Bounty.Particles.P_FX_LinkGun_MF_Primary
	MuzzleFlashAltPSCTemplate=Bounty.Particles.P_FX_LinkGun_MF_Primary
	MuzzleFlashColor=(R=120,G=180,B=255,A=255)
	MuzzleFlashDuration=0.2
	MuzzleFlashLightClass=class'MSGame.MSLaserGunMuzzleFlashLight'

	IconCoordinates=(U=728,V=382,UL=162,VL=45)

	WeaponColor=(R=160,G=180,B=255,A=255)

	InventoryGroup=4
	GroupWeight=0.5

	IconX=400
	IconY=129
	IconWidth=22
	IconHeight=48

	CurrentFireLevel=1
	FireLevelGap=90

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
   
}
