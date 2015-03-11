class MSWeap_BossPhase3 extends MSWeapon;

// here is a cool down time counter 
var Array<MSProj_OrangeBarrageSmall> SpawnedOranges;

// Green barrages properties
var bool IsGreenCoolDown;
var float GreenCoolDown;
var int GreenWaveCount;
var bool ResetGreenAim;
var Rotator GreenAim;

// Orange barrages properties
var bool IsOrangeCoolDown;
var bool ResetOrangeAim;
var float OrangeCoolDown;
var Rotator OrangeAim;
var int OrangeWaveCount;

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc)
{
	local MSProj_GreenBarrageSmall GreenProj;
	local MSProj_OrangeBarrageSmall OrangeProj;
	local Rotator AdjustedAim, SpawnRotOffset, OrangeRotTemp, GreenRotTemp;
	local int i, j, GreenCountPerWave, OrangeCountPerWave;
	local float HeightOffset;

	HeightOffset = 80.0;
	RealStartLoc.Z -= HeightOffset;

	AdjustedAim = GetAdjustedAim( RealStartLoc );
	if(AdjustedAim.Pitch < 0) AdjustedAim.Pitch = 0;

	if(ResetGreenAim)
	{
		GreenAim = AdjustedAim;
		GreenAim.Yaw  -= 30 * DegToUnrRot;
		ResetGreenAim = false;
		GreenWaveCount = 30; // 6 degrees between each other in total 180 degrees
	}

	if(ResetOrangeAim)
	{
		OrangeAim = AdjustedAim;
		OrangeAim.Yaw += DegToUnrRot * 30;
		ResetOrangeAim = false;
		OrangeWaveCount = 30; // 2 degrees between each other in 60 degrees
	}
	
	if(!IsGreenCoolDown)
	{
		GreenCountPerWave = CurrentFireLevel * 2;

		SpawnRotOffset.Pitch = 0;
		SpawnRotOffset.Roll = 0;
		SpawnRotOffset.Yaw = DegToUnrRot * 3;

		
		GreenRotTemp = GreenAim - (CurrentFireLevel - 0.5) * SpawnRotOffset;
		for(j = 0; j < GreenCountPerWave; j++)
		{
			GreenProj = Spawn(class'MSProj_GreenBarrageSmall' ,,, RealStartLoc );
			GreenProj.Speed += j * 100;
			GreenProj.LocalAcceleration += j * vect(0, 50, 0);
			GreenProj.Init(Vector(GreenRotTemp));
			GreenRotTemp += SpawnRotOffset;
		}

		GreenWaveCount--;
		if(GreenWaveCount == 0)
		{
			IsGreenCoolDown = true;
			SetTimer( GreenCoolDown, false, 'GreenCoolDownComplete');
		}

		if(GreenWaveCount <= 20 && GreenWaveCount > 10) GreenAim.Yaw -= DegToUnrRot * 6; 
		else GreenAim.Yaw += DegToUnrRot * 6 ;
	}

	if(!IsOrangeCoolDown)
	{
		OrangeCountPerWave = CurrentFireLevel + 1;

		SpawnRotOffset.Pitch = 0;
		SpawnRotOffset.Roll = 0;
		SpawnRotOffset.Yaw = DegToUnrRot * 2;

		OrangeRotTemp = OrangeAim - SpawnRotOffset * (OrangeCountPerWave - 1) / 2;

		for(i = 0; i < OrangeCountPerWave; i++)
		{
			OrangeProj = Spawn(class'MSProj_OrangeBarrageSmall' ,,, RealStartLoc);
			OrangeProj.Speed += i * 100;
			OrangeProj.AimDirection = OrangeRotTemp;
			OrangeProj.Init(Vector(OrangeRotTemp));
			SpawnedOranges.AddItem(OrangeProj);
			OrangeRotTemp += SpawnRotOffset;
		}
		OrangeAim.Yaw -= DegToUnrRot * 2;

		OrangeWaveCount--;
		if(OrangeWaveCount == 0)
		{
			IsOrangeCoolDown = true;
			SetTimer(1.0, false, 'OrangeSetOff');
			SetTimer(OrangeCoolDown, false, 'OrangeCoolDownComplete');
		}
	}
	
	return SpawnedOranges;
}

function GreenCoolDownComplete()
{
	ResetGreenAim = true;
	IsGreenCoolDown = false;
}

function OrangeCoolDownComplete()
{
	ResetOrangeAim = true;
	IsOrangeCoolDown = false;
}

function OrangeSetOff()
{
	local int i;
	for(i = 0; i < SpawnedOranges.Length; i++)
	{
		SpawnedOranges[i].SetOff();
	}
	SpawnedOranges.Remove(0,SpawnedOranges.Length);
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

	FireInterval(0)=+0.1
	FireInterval(1)=+0.15

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

	ResetGreenAim=true
	IsGreenCoolDown=false
	GreenCoolDown=4.0

	ResetOrangeAim=true
	IsOrangeCoolDown=false
	OrangeCoolDown=4.0

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
