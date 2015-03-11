class MSWeap_EnemyWeaponCyan extends MSWeapon;

var Rotator MultiProjectileRotOffset;

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local Array<Projectile> SpawnedProjectiles;
	local MSProj_CyanBarrageSmall SmallProj;
	local MSProj_CyanBarrageLarge LargeProj;
	local Rotator AdjustedAim, BaseAim;
	local int i;
	local Vector HitLoc, HitNormal;
	local TraceHitInfo HitInfo;
	local MSPawn HitPawn;
	local MSPlayerController Controller;

	MultiProjectileRotOffset.Pitch = 0;
	MultiProjectileRotOffset.Roll = 0;

	if( CurrentFireMode == 0)
	{
		MultiProjectileRotOffset.Yaw = DegToUnrRot * 8;
		AdjustedAim = GetAdjustedAim( RealStartLoc );
		if(AdjustedAim.Pitch < 0 ) AdjustedAim.Pitch = 0;
		BaseAim = AdjustedAim;
		AdjustedAim -= MultiProjectileRotOffset * 2.5;

		for(i = 0; i< 6; i++)
		{
			SpawnedProjectiles[i] = Spawn(GetProjectileClass(),,, RealStartLoc);
			
			SmallProj = MSProj_CyanBarrageSmall(SpawnedProjectiles[i]);
			if(SmallProj != none)
				SmallProj.FinalDirection = Normal(Vector(BaseAim));

			SpawnedProjectiles[i].Init(Vector(AdjustedAim));
			AdjustedAim +=  MultiProjectileRotOffset;
		}
		return SpawnedProjectiles;
	}
	else if( CurrentFireMode == 1)
	{
		MultiProjectileRotOffset.Yaw = DegToUnrRot * 30;

		AdjustedAim = GetAdjustedAim( RealStartLoc );

		HitPawn = MSPawn( Trace( HitLoc, HitNormal, Normal(Vector(AdjustedAim)) * 65535 + RealStartLoc, RealStartLoc, true , , HitInfo));
		if(HitPawn != none)
			Controller = MSPlayerController(HitPawn.Controller);
		else Controller = none;

		AdjustedAim -= MultiProjectileRotOffset * 0.5;

		for(i = 0; i< 2; i++)
		{
			SpawnedProjectiles[i] = Spawn(GetProjectileClass(),,, RealStartLoc);

			LargeProj = MSProj_CyanBarrageLarge(SpawnedProjectiles[i]);
			if(LargeProj != none && HitPawn != none)
				LargeProj.SeekTarget = HitPawn;

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

	AttachmentClass=class'MSWeaponAttachment_EnemyWeaponCyan'
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
	End Object

	Begin Object Class=StaticMeshComponent Name=MeshComponentA
		StaticMesh=StaticMesh'Bounty.Mesh.MSFirePowerSmall'
		Materials(0)=Material'Bounty.Materials.MSFirePowerLarge_Material'
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

	DroppedInventoryClass=class'MSFirePowerLarge'

    WeaponFireTypes(0)=EWFT_MultiProjectile
	WeaponFireTypes(1)=EWFT_MultiProjectile
    WeaponProjectiles(0)=class'MSProj_CyanBarrageSmall'
	WeaponProjectiles(1)=class'MSProj_CyanBarrageLarge'

	WeaponEquipSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_RaiseCue'
	WeaponPutDownSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_LowerCue'
	WeaponFireSnd(0)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	WeaponFireSnd(1)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	FireInterval(0)=+0.5
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

	CurrentFireLevel=1

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
   
}
