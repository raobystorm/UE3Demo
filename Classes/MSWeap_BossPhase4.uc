class MSWeap_BossPhase4 extends MSWeapon;


simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local MSProj_ExplosionSphere_Slow SlowProj;
	local Rotator AdjustedAim;
	local float HeightOffset;
	local array<Projectile> Projectiles;

	HeightOffset = 80.0;
	RealStartLoc.Z -= HeightOffset;

	AdjustedAim = GetAdjustedAim(RealStartLoc);

	SlowProj = Spawn(class'MSProj_ExplosionSphere_Slow',,, RealStartLoc);
	SlowProj.Init(Vector(AdjustedAim));
	Projectiles.AddItem(SlowProj);
	
	return Projectiles;
}

defaultproperties
{
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	AttachmentClass=class'MSWeaponAttachment_EnemyWeaponWeak'
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
	End Object

    WeaponFireTypes(0)=EWFT_MultiProjectile
	WeaponFireTypes(1)=EWFT_MultiProjectile

    WeaponProjectiles(0)=class'MSProj_ExplosionSphere_Slow'
	WeaponProjectiles(1)=class'MSProj_ExplosionSphere_Slow'

	WeaponEquipSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_RaiseCue'
	WeaponPutDownSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_LowerCue'
	WeaponFireSnd(0)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	WeaponFireSnd(1)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'
	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	FireInterval(0)=+1.5
	FireInterval(1)=+1.5

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

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
   
}
