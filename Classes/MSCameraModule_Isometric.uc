class MSCameraModule_Isometric extends MSCameraModule;

var(MahoShojo) float CamOffset; //actual camera offset from player
var float CamHorizontalOffset; // Equals Cos( UnrRotToRad * IsoCamAngle ) * CamOffset
var float CamVerticalOffset; // Equals Sin( UnrRotToRad * IsoCamAngle ) * CamOffset
var(MahoShojo) float DesiredCamOffset; //new height offset to move camera to
var(MahoShojo) float MaxCamOffset; //maximum offset from player camera can be
var(MahoShojo) float MinCamOffset; //minimum offset from player camera can be
var(MahoShojo) float CamZoomIncrement; //how many units to zoom with each click of mousewheel
var(MahoShojo) int IsoCamAngle; //the angle of camera look down
var(MahoShojo) int MaxCamAngle;
var(MahoShojo) int MinCamAngle;

var Vector CamDesiredLocation;// The ideal location of camera in next camera update process

//Whether the camera is currently preventing spin, for example if it is heavily collided it will prevent spin.
var(MahoShojo) bool PreventCameraSpin;
var(MahoShojo) float CurrentCameraSpin;
var Vector CurrentCameraRotationOffset;

var(MahoShojo) float TargetLocationInterpSpeed;

var Vector LastCameraLocation;
var Rotator LastCameraRotation;
var float LastCameraFOV;

// The last target we viewing before
var Actor LastViewTarget;

var bool IsCameraSpinningLeft;
var bool IsCameraSpinningRight;

//Calculate new camera location and rotation
function UpdateCamera(Pawn P, MSPlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
	local Vector HitLocation, HitNormal, TempLoc;
	local Rotator TempRot;
	local TraceHitInfo TraceHitInfo;
	
	CamHorizontalOffset = Cos( UnrRotToRad * IsoCamAngle) * CamOffset;
	// Check if the target pawn is dead or not
	if(MSPawn(OutVT.Target) != none && MSPawn(OutVT.Target).Dead)
	{
		OutVT.POV.Location=LastCameraLocation;
		OutVT.POV.Rotation=LastCameraRotation;
	}
	else
	{
		if(LastViewTarget != OutVT.Target )
		{
			ResetInterpolations( OutVT.Target );
			LastViewTarget = OutVT.Target;
		}
	
		//interpolate to new camera offest if not there
		if(CamOffset != DesiredCamOffset)
		{
			CamOffset += (DesiredCamOffset - CamOffset) * DeltaTime * TargetLocationInterpSpeed;
			CamHorizontalOffset = Cos( UnrRotToRad * IsoCamAngle ) * CamOffset;
			CamVerticalOffset = Sin( UnrRotToRad * IsoCamAngle ) * CamOffset;
			SpinCamera(0, false);
		}

		//align camera to player with height (Z) offset
		TempRot.Pitch = 0;
		TempRot.Yaw = 32768 - RadToUnrRot * CurrentCameraSpin * Pi;
		TempRot.Roll = 0;

		TempLoc.X = CamOffset/2.5;
		TempLoc.Y = 0;
		TempLoc.Z = 0;

		CamDesiredLocation = OutVT.Target.Location + (TempLoc >> TempRot);
		CamDesiredLocation.Z +=CamVerticalOffset;
		CamDesiredLocation.X += CurrentCameraRotationOffset.X;
		CamDesiredLocation.Y -= CurrentCameraRotationOffset.Y;

		//Using the camera instance to trace and check collision
		if( PlayerCamera.CheckCamCollision(HitLocation, HitNormal, CamDesiredLocation, LastCameraLocation, TraceHitInfo))
		{
			ProcessCollision(HitLocation, HitNormal, CamDesiredLocation, TraceHitInfo, DeltaTime);
		}else
		{
			PreventCameraSpin = false;
		}
		OutVT.POV.Location = CamDesiredLocation;

		//set camera rotation - face down
		OutVT.POV.Rotation.Pitch = -1 * IsoCamAngle;
		OutVT.POV.Rotation.Yaw = 32768 - RadToUnrRot * CurrentCameraSpin * Pi;
		OutVT.POV.Rotation.Roll = 0;

		LastCameraLocation = OutVT.POV.Location;
		LastCameraRotation = OutVT.POV.Rotation;

		if(IsCameraSpinningLeft)
		{
			// Due to personal control habbit, I reversed the left and right turning in camera module
			SpinCamera(CamSpinSpeed * 950, false);
		}
		else if(IsCameraSpinningRight)
		{
			SpinCamera(-1.0 * CamSpinSpeed * 950, false);
		}
	}
}

//initialize new view target
simulated function BecomeViewTarget( MSPlayerController PC )
{
   if (LocalPlayer(PC.Player) != None)
      {
      //Set player mesh visible
        PC.SetBehindView(true);
        MSPawn(PC.Pawn).SetMeshVisibility(PC.bBehindView);
        PC.bNoCrosshair = true;
      }
}

function StartSpinCameraLeft()
{
	IsCameraSpinningLeft = true;
}

function StartSpinCameraRight()
{
	IsCameraSpinningRight = true;
}

function StopSpinCameraLeft()
{
	IsCameraSpinningLeft = false;
}

function StopSpinCameraRight()
{
	IsCameraSpinningRight = false;
}

//Check if there is a CameraSpin input
function UpdateCameraSpin()
{
	local MSHUD myHUD;
	local Vector2D MouseCoords;
	local MSPlayerInput PlayerInput;

	myHUD = MSHUD(PlayerCamera.PCOwner.myHUD);
	PlayerInput = MSPlayerInput(PlayerCamera.PCOwner.PlayerInput);
	
	if(myHUD != none)
	{
		MouseCoords = myHUD.GetMouseCoordinates();
		if(myHUD.IsOnLeftOfCanvas(MouseCoords, 0.015) && PlayerInput.aMouseX < 0)
		{
			SpinCamera( PlayerInput.aMouseX * CamSpinSpeed, false);
		}
		else if(myHUD.IsOnRightOfCanvas(MouseCoords, 0.015) && PlayerInput.aMouseX > 0)
		{
			SpinCamera( PlayerInput.aMouseX * CamSpinSpeed, false);
		}
		else if(myHUD.IsOnTopOfCanvas(MouseCoords, 0.015))
		{
			RollCamera( PlayerInput.aMouseY * CamRollSpeed);
		}
		else if(myHUD.IsOnBottomOfCanvas(MouseCoords, 0.015))
		{
			RollCamera( PlayerInput.aMouseY * CamRollSpeed);
		}
	}
}

/*
 * Due to we create camera module class directly from the object class,
 * There is no trace function available in this class domaint, so a call to
 * the camera class for trace is neccessary.
 */
function ProcessCollision(Vector HitLoc, Vector HitNormal, Vector TargetLoc, TraceHitInfo HitInfo, float DeltaTime)
{
	local Vector TraceHitLoc, TraceHitNormal, PawnLocation;
	local TraceHitInfo TraceCheckHitInfo;

	PawnLocation = PlayerCamera.PlayerOwner.Pawn.Location;

	// We need to perform trace again to check whether our player is 
	// visible or not, in order to avoid camera dead loop for the collision 
	// situation, this is neccessary process.
	if(PlayerCamera.CheckCamCollision( TraceHitLoc, TraceHitNormal, LastCameraLocation, PawnLocation, TraceCheckHitInfo))
	{
		CamDesiredLocation = TraceHitLoc + TraceHitNormal * CameraCollisionOffset;
	}
	else 
	{
		HitLoc += Normal(PawnLocation - HitLoc) * CameraCollisionOffset;
		PreventCameraSpin = (VSize(PawnLocation - HitLoc) < 100);
		CamDesiredLocation =VSize(PawnLocation - HitLoc) < 100 ? LastCameraLocation : HitLoc;
	}
}

function SpinCamera(float amount, optional bool forceSpin)
{
	local float radAmount;

	//if we're not allowing spin right (probably due to a collided camera, then don't)
	if(PreventCameraSpin && !forceSpin)
		return;

	//increment our spin value
	CurrentCameraSpin += amount;

	//and calculate our translation offset as the circle coordinates at this angle
	radAmount = CurrentCameraSpin * Pi;
	CurrentCameraRotationOffset.x = CamHorizontalOffset * Cos(radAmount);
	CurrentCameraRotationOffset.y = CamHorizontalOffset * Sin(radAmount);
}

function RollCamera(float amount)
{
	IsoCamAngle += RadToUnrRot * amount;
	IsoCamAngle = Min(MaxCamAngle, IsoCamAngle);
	IsoCamAngle = Max(MinCamAngle, IsoCamAngle);
}

function ZoomIn()
{
   //decrease camera height
   DesiredCamOffset -= CamZoomIncrement;
   
   //lock camera height to limits
   DesiredCamOffset = FMin(MaxCamOffset, FMax(MinCamOffset, DesiredCamOffset));
}

function ZoomOut()
{
   //increase camera height
   DesiredCamOffset += CamZoomIncrement;

   //lock camera height to limits
   DesiredCamOffset = FMin(MaxCamOffset, FMax(MinCamOffset, DesiredCamOffset));
}

function ResetInterpolations(Actor target)
{
	local MSHUD HUD;
	//reset all of our interpolation values to immediately fully utilize from the target's transformation
	CurrentCameraSpin = 0;
	SpinCamera(0);
	LastCameraLocation = PlayerCamera.Location;
	LastCameraRotation = PlayerCamera.Rotation;
	//if using mouse control, reset the mouse position to the upper-center area of the screen, so that our character doesn't immediately start turning around (depending on where the cursor was)
	HUD = MSHUD(PlayerCamera.PlayerOwner.myHUD);

	if(HUD != none)
	{
		HUD.SetMousePosCenter();
	}
}

final function Rotator LookAt(Vector direction)
{
	local Rotator newRot;
	direction = normal(direction);
	newRot.Yaw = RadToUnrRot*Atan2(direction.Y, direction.X);
	newRot.Pitch = RadToUnrRot*Atan2(direction.Z, Sqrt((direction.X*direction.X) + (direction.Y*direction.Y)));
	return newRot;
}

defaultproperties
{
	TargetLocationInterpSpeed=3
	CamOffset=383.0
	CamSpinSpeed=0.00001f
	CameraCollisionOffset=50
	PreventCameraSpin=false
	CurrentCameraSpin=0.f
	DesiredCamOffset=480.0
	MaxCamOffset=1024.0
	MinCamOffset=160.0
	CamZoomIncrement=96.0
	IsoCamAngle=8192 // 45 degrees
	MaxCamAngle=10922// 55degrees
	MinCamAngle=7281 // 35 degrees
	CamRollSpeed=0.00001f
}
