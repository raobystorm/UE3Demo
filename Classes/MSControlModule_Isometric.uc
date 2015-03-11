class MSControlModule_Isometric extends MSControlModule;

var float RotationInterpSpeed;
var Rotator PawnPOVRotation;
var float AimLocationOffset;

//Calculate Pawn aim rotation
simulated singular function Rotator GetBaseAimRotation(Vector StartFireLoc)
{
	local rotator   POVRot;
	local Vector MouseLocation;
	local MSHUD myHUD;

	//aim where Pawn is facing - lock pitch
	POVRot = Controller.Pawn.Rotation;
	myHUD = MSHUD(Controller.myHUD);
	if(myHUD != none)
	{
		MouseLocation = myHUD.MouseProjectionLocation;
		if(myHUD.MouseTarget != none)
		{
			if( MSPlayer(myHUD.MouseTarget) != none )
			{
				POVRot = Controller.Pawn.Rotation;
			}
			else
			{
				POVRot = LookAt(myHUD.MouseTarget.Location - StartFireLoc);
			}
		}
		else
		{
			POVRot = LookAt(MouseLocation - StartFireLoc);
		}

		//POVRot.Pitch = 0;
		return POVRot;
	}
}

//Handle custom player movement
function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
{
	local Rotator CameraRotationYawOnly;

	CameraRotationYawOnly.Yaw = Controller.PlayerCamera.ViewTarget.POV.Rotation.Yaw;

	if( Controller.Pawn == None )
	{
		return;
	}

    if (Controller.Role == ROLE_Authority)
    {
       // Update ViewPitch for remote clients
        Controller.Pawn.SetRemoteViewPitch( Controller.Rotation.Pitch );
    }

    Controller.Pawn.Acceleration.X = Controller.PlayerInput.aForward;
	Controller.Pawn.Acceleration.Y = Controller.PlayerInput.aStrafe;
	Controller.Pawn.Acceleration.Z = 0;

	Controller.Pawn.Acceleration = Controller.TransformVectorByRotation( CameraRotationYawOnly, Controller.Pawn.Acceleration);

	Controller.CheckJumpOrDuck();
}

function ProcessMoveInWater(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
{
	local Rotator CameraRotationYawOnly;

	CameraRotationYawOnly.Yaw = Controller.PlayerCamera.ViewTarget.POV.Rotation.Yaw;
	if( Controller.Pawn == None )
	{
		return;
    }

    if (Controller.Role == ROLE_Authority)
    {
       // Update ViewPitch for remote clients
        Controller.Pawn.SetRemoteViewPitch( Controller.Rotation.Pitch );
    }

    Controller.Pawn.Acceleration.X = Controller.PlayerInput.aForward;
	Controller.Pawn.Acceleration.Y = Controller.PlayerInput.aStrafe;
	//Different from land movement, acceleration equals 0 will make landing failed
	Controller.Pawn.Acceleration.Z = NewAccel.Z;

	Controller.Pawn.Acceleration = Controller.TransformVectorByRotation( CameraRotationYawOnly, Controller.Pawn.Acceleration);

	Controller.CheckJumpOrDuck();
}

//Calculate controller rotation
function UpdateRotation(float DeltaTime)
{
	local MSHUD myHUD;
	local Vector MouseLocation, PawnLocation;

	PawnLocation = Controller.Pawn.Location;
	myHUD = MSHUD(Controller.myHUD);

	if(myHUD != none )
	{
		MouseLocation = myHUD.MouseProjectionLocation;

		MouseLocation -= PawnLocation;
		PawnPOVRotation.Yaw = RadToUnrRot * Atan2(MouseLocation.Y, MouseLocation.X);
		
		if(Controller.Pawn != None )
			Controller.Pawn.FaceRotation(PawnPOVRotation, DeltaTime);

		Controller.Pawn.SetViewRotation(PawnPOVRotation);
	}
}

function Rotator LookAt(Vector direction)
{
	local Rotator newRot;
	direction = normal(direction);
	newRot.Yaw = RadToUnrRot*Atan2(direction.Y, direction.X);
	newRot.Pitch = RadToUnrRot*Atan2(direction.Z, Sqrt((direction.X*direction.X) + (direction.Y*direction.Y)));
	return newRot;
}

defaultproperties
{
	AimLocationOffset=14.14
	PawnPOVRotation=(Pitch=0,Roll=0,Yaw=0)
}
