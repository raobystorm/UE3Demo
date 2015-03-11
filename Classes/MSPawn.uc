class MSPawn extends UTPawn;

// Mark if the pawn is dead or not
var bool Dead;

var int CurrentFirePower;
var int MaxFirePower;

/* BecomeViewTarget
   Called by Camera when this actor becomes its ViewTarget */
simulated event BecomeViewTarget( PlayerController PC )
{
   local MSPlayerController MSPC;

   MSPC = MSPlayerController(PC);

   //Pawn is controlled by a MSPlayerController and has a MSPlayerCamera
      if(MSPC != none && MSPlayerCamera(MSPC.PlayerCamera) != none)
      {
      //allow custom camera to control mesh visibility, etc.
      MSPlayerCamera(MSPC.PlayerCamera).BecomeViewTarget(MSPC);
      }
      else
      {
      Super.BecomeViewTarget(PC);
   }
}

function bool DoJump( bool bUpdating )
{
	if (bJumpCapable && !bIsCrouched && !bWantsToCrouch && (Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider))
	{
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )
			Velocity.Z = Default.JumpZ;
		else
			Velocity.Z = JumpZ;
		if (Base != None && !Base.bWorldGeometry && Base.Velocity.Z > 0.f)
		{
			Velocity.Z += Base.Velocity.Z;
		}
		SetPhysics(PHYS_Falling);
		return true;
	}
	return false;
}

/**
 *   Calculate camera view point, when viewing this pawn.
 *
 * @param   fDeltaTime   delta time seconds since last update
 * @param   out_CamLoc   Camera Location
 * @param   out_CamRot   Camera Rotation
 * @param   out_FOV      Field of View
 *
 * @return   true if Pawn should provide the camera point of view.
 */
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   //return false to allow custom camera to control its location and rotation
      return false;
}


simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
	local UTPlayerReplicationInfo PRI;
	local int i;
	local int TeamNum;
	local MaterialInterface TeamMaterialHead, TeamMaterialBody;

	PRI = GetUTPlayerReplicationInfo();
	//Info = class'MSGame.MSBossCharacterInfo';

	if (Info != CurrCharClassInfo)
	{
		// Set Family Info
		CurrCharClassInfo = Info;

		// get the team number (0 red, 1 blue, 255 no team)
		TeamNum = GetTeamNum();

		// AnimSets
		Mesh.AnimSets = Info.default.AnimSets;

		//Apply the team skins if necessary
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			Info.static.GetTeamMaterials(TeamNum, TeamMaterialHead, TeamMaterialBody);
		}

		// 3P Mesh and materials
		SetCharacterMeshInfo(Info.default.CharacterMesh, TeamMaterialHead, TeamMaterialBody);

		// PhysicsAsset
		// Force it to re-initialise if the skeletal mesh has changed (might be flappy bones etc).
		Mesh.SetPhysicsAsset(Info.default.PhysAsset, true);

		// Make sure bEnableFullAnimWeightBodies is only TRUE if it needs to be (PhysicsAsset has flappy bits)
		Mesh.bEnableFullAnimWeightBodies = FALSE;
		for(i=0; i<Mesh.PhysicsAsset.BodySetup.length && !Mesh.bEnableFullAnimWeightBodies; i++)
		{
			// See if a bone has bAlwaysFullAnimWeight set and also
			if( Mesh.PhysicsAsset.BodySetup[i].bAlwaysFullAnimWeight &&
				Mesh.MatchRefBone(Mesh.PhysicsAsset.BodySetup[i].BoneName) != INDEX_NONE)
			{
				Mesh.bEnableFullAnimWeightBodies = TRUE;
			}
		}

		//Overlay mesh for effects
		if (OverlayMesh != None)
		{
			OverlayMesh.SetSkeletalMesh(Info.default.CharacterMesh);
		}

		//Set some properties on the PRI
		if (PRI != None)
		{
			PRI.bIsFemale = Info.default.bIsFemale;
			PRI.VoiceClass = Info.static.GetVoiceClass();

			// Assign fallback portrait.
			PRI.CharPortrait = Info.static.GetCharPortrait(TeamNum);

			// a little hacky, relies on presumption that enum vals 0-3 are male, 4-8 are female
			if ( PRI.bIsFemale )
			{
				PRI.TTSSpeaker = ETTSSpeaker(Rand(4));
			}
			else
			{
				PRI. TTSSpeaker = ETTSSpeaker(Rand(5) + 4);
			}
		}

		// Bone names
		LeftFootBone = Info.default.LeftFootBone;
		RightFootBone = Info.default.RightFootBone;
		TakeHitPhysicsFixedBones = Info.default.TakeHitPhysicsFixedBones;

		// sounds
		SoundGroupClass = Info.default.SoundGroupClass;

		Mesh.SetScale(DefaultMeshScale);
		CrouchTranslationOffset = BaseTranslationOffset + CylinderComponent.Default.CollisionHeight - CrouchHeight;
	}
}

defaultproperties
{
	DefaultMeshScale=1.3
	BaseTranslationOffset = 18

	Health=200
	HealthMax=200
	SuperHealthMax=200

	CurrentFirePower=0
	MaxFirePower=200

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0027.000000
		CollisionHeight=+0057.000000
	End Object
	CylinderComponent=CollisionCylinder
}
