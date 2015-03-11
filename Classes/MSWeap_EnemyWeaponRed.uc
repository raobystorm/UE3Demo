class MSWeap_EnemyWeaponRed extends MSWeapon;

// In the multi-projectile shooting mode, rotation offset of each projectile
var Rotator MultiProjectileRotOffset;

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local Array<Projectile> SpawnedProjectiles;
	local Rotator AdjustedAim;
	local int i;

	MultiProjectileRotOffset.Pitch = 0;
	MultiProjectileRotOffset.Roll = 0;

	if( CurrentFireMode == 0)
	{
		MultiProjectileRotOffset.Yaw = DegToUnrRot * 9;
		AdjustedAim = GetAdjustedAim( RealStartLoc );
		AdjustedAim -= MultiProjectileRotOffset * 2;
		if(AdjustedAim.Pitch < 0 ) AdjustedAim.Pitch = 0;

		for(i = 0; i< 5; i++)
		{
			SpawnedProjectiles[i] = Spawn(GetProjectileClass(),,, RealStartLoc);
			SpawnedProjectiles[i].Init(Vector(AdjustedAim));
			AdjustedAim +=  MultiProjectileRotOffset;
		}
		return SpawnedProjectiles;
	}
	else if( CurrentFireMode == 1)
	{
		MultiProjectileRotOffset.Yaw = DegToUnrRot * 30;
		AdjustedAim = GetAdjustedAim( RealStartLoc );
		AdjustedAim -= MultiProjectileRotOffset * 0.5;

		for(i = 0; i< 2; i++)
		{
			SpawnedProjectiles[i] = Spawn(GetProjectileClass(),,, RealStartLoc);
			SpawnedProjectiles[i].Init(Vector(AdjustedAim));
			AdjustedAim +=  MultiProjectileRotOffset;
		}
		return SpawnedProjectiles;
	}
}

defaultproperties
{
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	AttachmentClass=class'MSWeaponAttachment_EnemyWeaponRed'
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
	End Object

	Begin Object Class=StaticMeshComponent Name=MeshComponentA
		StaticMesh=StaticMesh'Bounty.Mesh.MSFirePowerSmall'
		Materials(0)=Material'Bounty.Materials.MSFirePowerMiddle_Material'
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		bAcceptsLights=true
		CollideActors=false
		BlockRigidBody=false
		Scale=2.5
		MaxDrawDistance=8000
		Translation=(X=0.0,Y=0.0,Z=+5.0)
	End Object
	DroppedPickupMesh=MeshComponentA

	DroppedInventoryClass=class'MSFirePowerMiddle'

    WeaponFireTypes(0)=EWFT_MultiProjectile
	WeaponFireTypes(1)=EWFT_MultiProjectile
    WeaponProjectiles(0)=class'MSProj_RedBarrageSmall'
	WeaponProjectiles(1)=class'MSProj_RedBarrageLarge'

	WeaponEquipSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_RaiseCue'
	WeaponPutDownSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_LowerCue'
	WeaponFireSnd(0)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	WeaponFireSnd(1)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	FireInterval(0)=+0.8
	FireInterval(1)=+2.0

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

	AmmoCount=1
	LockerAmmoCount=1
	MaxAmmoCount=1

	IconCoordinates=(U=728,V=382,UL=162,VL=45)

	WeaponColor=(R=160,G=180,B=255,A=255)

	InventoryGroup=4
	GroupWeight=0.5

	IconX=400
	IconY=129
	IconWidth=22
	IconHeight=48

	CurrentFireLevel=1

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
   
}
