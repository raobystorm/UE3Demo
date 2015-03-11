class MSPowerUp_EnergeticD extends MSPowerUpItem;

/** overlay material applied to owner */
var MaterialInterface OverlayMaterialInstance;
/** ambient sound played while active*/
var SoundCue ActiveAmbientSound;

function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
	local MSPlayer P;

	Super.GivenTo(NewOwner, bDoNotActivate);

	P = MSPlayer(NewOwner);
	if (P != None)
	{
		P.StaminaDrainMultiplier = 0.3;
		// apply UDamage overlay
		P.SetPawnAmbientSound(ActiveAmbientSound);
	}
}

function ItemRemovedFromInvManager()
{
	local UTPlayerReplicationInfo UTPRI;
	local UTPawn P;

	MSPlayer(Owner).StaminaDrainMultiplier = 1.0;
	P = UTPawn(Owner);
	if (P != None)
	{
		P.SetPawnAmbientSound(none);
		//Stop the timer on the powerup stat
		if (P.DrivenVehicle != None)
		{
			UTPRI = UTPlayerReplicationInfo(P.DrivenVehicle.PlayerReplicationInfo);
		}
		else
		{
			UTPRI = UTPlayerReplicationInfo(P.PlayerReplicationInfo);
		}
		if (UTPRI != None)
		{
			UTPRI.StopPowerupTimeStat(GetPowerupStatName());
		}
	}
}

defaultproperties
{
	PowerupStatName=POWERUPTIME_ENERGETICD

	Begin Object Class=StaticMeshComponent Name=MeshComponentA
		StaticMesh=StaticMesh'Bounty.Mesh.MSPowerUp_EnergeticD'
		Materials(0)=Material'Bounty.Materials.TransparentYellow'
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		bAcceptsLights=true
		CollideActors=false
		BlockRigidBody=false
		Scale=1.0
		MaxDrawDistance=8000
		Translation=(X=0.0,Y=0.0,Z=+5.0)
	End Object
	DroppedPickupMesh=MeshComponentA
	PickupFactoryMesh=MeshComponentA

	Begin Object Class=UTParticleSystemComponent Name=PickupParticles
		Template=ParticleSystem'Pickups.UDamage.Effects.P_Pickups_UDamage_Idle'
		bAutoActivate=false
		SecondsBeforeInactive=1.0f
		Translation=(X=0.0,Y=0.0,Z=+5.0)
	End Object
	DroppedPickupParticles=PickupParticles

	TimeRemaining=15.0
	bReceiveOwnerEvents=true
	PickupSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_PickupCue'
	PowerupOverSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_EndCue'
	OverlayMaterialInstance=Material'Pickups.UDamage.M_UDamage_Overlay'
	ActiveAmbientSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_PowerLoopCue'
	HudIndex=0
	IconCoords=(U=792,UL=43,V=41,VL=58)

	PP_Scene_Highlights=(X=-0.1,Y=0.04,Z=-0.2)
}
