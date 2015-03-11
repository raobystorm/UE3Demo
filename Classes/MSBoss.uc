class MSBoss extends MSPawn
   placeable;

var SkeletalMesh BossMesh;

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
		TeamNum = 0;

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
	ControllerClass=class'MSGame.MSBossController'

	Health=11000
	HealthMax=11000
	SuperHealthMax=22000

	DefaultMeshScale=3.0
	BaseTranslationOffset = 48.0
	GroundSpeed=270
	
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0045.000000
		CollisionHeight=+0150.000000
	End Object
	CylinderComponent=CollisionCylinder

}