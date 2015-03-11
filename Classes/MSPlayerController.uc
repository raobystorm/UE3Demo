class MSPlayerController extends UTPlayerController
	config(Game);

var class<UTFamilyInfo> CharacterClass;

var MSControlModule ControlModule; //player control module to use
var config string DefaultControlModuleClass; //default class for player control module

//exec function for switching to a different camera by class
exec function ChangeControls( string ClassName )
{
   local class<MSControlModule> ControlClass;
   local MSControlModule NewControlModule;

   ControlClass = class<MSControlModule>( DynamicLoadObject( DefaultControlModuleClass, class'Class' ) );
   
   if(ControlClass != none)
   {
      // Associate module with PlayerController
      NewControlModule = new(Outer) ControlClass;
      NewControlModule.Controller = self;
      NewControlModule.Init();

      //call active/inactive functions on new/old modules
      if(ControlModule != none)
      {
         ControlModule.OnBecomeInactive(NewControlModule);
         NewControlModule.OnBecomeActive(ControlModule);
      }
      else
      {
         NewControlModule.OnBecomeActive(None);
      }

      ControlModule = NewControlModule;
   }
   else
   {
      `log("Couldn't get control module class!");
      // not having a Control Class is fine.  PlayerController will use default controls.
   }
}

//exec function for switching to a different camera by class
exec function ChangeCamera( string ClassName )
{
   local class<MSCameraModule> NewClass;

   NewClass = class<MSCameraModule>( DynamicLoadObject( ClassName, class'Class' ) );

   if(NewClass != none && MSPlayerCamera(PlayerCamera) != none)
   {
      MSPlayerCamera(PlayerCamera).CreateCamera(NewClass);
   }
}

//zoom in exec
exec function ZoomIn()
{
   if(MSPlayerCamera(PlayerCamera) != none)
   {
      MSPlayerCamera(PlayerCamera).ZoomIn();
   }
}

//zoom out exec
exec function ZoomOut()
{
   if(MSPlayerCamera(PlayerCamera) != none)
   {
      MSPlayerCamera(PlayerCamera).ZoomOut();
   }
}

exec function RaobyIsAllMighty()
{
	local MSPlayer Player;
	Player = MSPlayer(Pawn);

	if(Player != none)
	{
		Player.Health  = 5000;
		Player.HealthMax = 5000;
		Player.SuperHealthMax = 5000;

		Player.CurrentFirePower = 200;

		ClientMessage("All-mighty Raoby is watching over you!");
	}
}

exec function StartSpinCameraLeft()
{
	local MSPlayerCamera Camera;

	Camera = MSPlayerCamera(PlayerCamera);
	if( Camera != none )
	{
		Camera.CurrentCamera.StartSpinCameraLeft();
	}
}

exec function StopSpinCameraLeft()
{
	local MSPlayerCamera Camera;

	Camera = MSPlayerCamera(PlayerCamera);
	if( Camera != none )
	{
		Camera.CurrentCamera.StopSpinCameraLeft();
	}
}

exec function StopSpinCameraRight()
{
	local MSPlayerCamera Camera;

	Camera = MSPlayerCamera(PlayerCamera);
	if( Camera != none )
	{
		Camera.CurrentCamera.StopSpinCameraRight();
	}
}

exec function StartSpinCameraRight()
{
	local MSPlayerCamera Camera;

	Camera = MSPlayerCamera(PlayerCamera);
	if( Camera != none )
	{
		Camera.CurrentCamera.StartSpinCameraRight();
	}
}

exec function StartThirdFire( optional Byte FireModeNum )
{
	StartFire( 2 );
}

exec function StopThirdFire( optional byte FireModeNum )
{
	StopFire( 2 );
}

exec function StartRunning()
{
	local MSPlayer Player;

	Player = MSPlayer(Pawn);
	if(Player != none)
	{
		Player.StartRunning();
	}
}

exec function StopRunning()
{
	local MSPlayer Player;

	Player = MSPlayer(Pawn);
	if(Player != none)
	{
		Player.StopRunning();
	}
}

simulated function PostBeginPlay()
{
   local class<MSControlModule> ControlClass;
   local MSControlModule NewControlModule;

   Super.PostBeginPlay();

   ControlClass = class<MSControlModule>( DynamicLoadObject( DefaultControlModuleClass, class'Class' ) );
   
   if(ControlClass != none)
   {
      // Associate module with PlayerController
      NewControlModule = new(Outer) ControlClass;
      NewControlModule.Controller = self;
      NewControlModule.Init();

      //call active/inactive functions on new/old modules
      if(ControlModule != none)
      {
         ControlModule.OnBecomeInactive(NewControlModule);
         NewControlModule.OnBecomeActive(ControlModule);
      }
      else
      {
         NewControlModule.OnBecomeActive(None);
      }

      ControlModule = NewControlModule;
   }
   else
   {
      `log("Couldn't get control module class!");
      // not having a Control Class is fine.  PlayerController will use default controls.
   }

   ServerSetCharacterClass(CharacterClass);
}

function UpdateRotation( float DeltaTime )
{
   //Controller has a MSPlayerCamera
   if(ControlModule != none)
   {
      //allow custom camera to update our rotation
      ControlModule.UpdateRotation(DeltaTime);
   }
    else
    {
         Super.UpdateRotation(DeltaTime);
   }
}

state PlayerWalking
{
   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
      //Controller has a MSPlayerCamera
      if(ControlModule != none)
      {
         //allow custom camera to override player movement
         ControlModule.ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
      }
        else
        {
         Super.ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
        }
    }

	function PlayerMove( float DeltaTime )
	{
		local vector			X,Y,Z, NewAccel;
		local eDoubleClickDir	DoubleClickMove;
		local rotator			OldRotation;
		local bool				bSaveJump;

		if( Pawn == None )
		{
			GotoState('Dead');
		}
		else
		{
			GetAxes(Pawn.Rotation,X,Y,Z);

			// Update acceleration.
			NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
			NewAccel.Z	= 0;
			NewAccel = Pawn.AccelRate * Normal(NewAccel);

			DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );

			// Update rotation.
			OldRotation = Rotation;

			MSPlayerCamera(PlayerCamera).CurrentCamera.UpdateCameraSpin();

			self.UpdateRotation( DeltaTime );
			bDoubleJump = false;

			if( bPressedJump && Pawn.CannotJumpNow() )
			{
				bSaveJump = true;
				bPressedJump = false;
			}
			else
			{
				bSaveJump = false;
			}

			if( Role < ROLE_Authority ) // then save this move and replicate it
			{
				Super.ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
			}
			else
			{
				ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
			}
			bPressedJump = bSaveJump;
		}
	}
}

state PlayerSwimming
{
   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
      //Controller has a MSPlayerCamera
      if(ControlModule != none)
      {
         //allow custom camera to override player movement
         ControlModule.ProcessMoveInWater(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
      }
      else
      {
		Super.ProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
      }
   }

   function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;

		if (Pawn == None)
		{
			GotoState('Dead');
		}
		else
		{
			GetAxes(Rotation,X,Y,Z);

			NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);
			NewAccel = Pawn.AccelRate * Normal(NewAccel);

			// Update rotation.
			oldRotation = Rotation;
			self.UpdateRotation( DeltaTime );

			MSPlayerCamera(PlayerCamera).CurrentCamera.UpdateCameraSpin();

			if ( Role < ROLE_Authority ) // then save this move and replicate it
			{
				ReplicateMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
			}
			else
			{
				ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
			}
			bPressedJump = false;
		}
	}
}


/**
 * Adjusts weapon aiming direction.
 * Gives controller a chance to modify the aiming of the pawn. For example aim error, auto aiming, adhesion, AI help...
 * Requested by weapon prior to firing.
 *
 * @param	W, weapon about to fire
 * @param	StartFireLoc, world location of weapon fire start trace, or projectile spawn loc.
 * @param	BaseAimRot, original aiming rotation without any modifications.
 */
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	//local vector	FireDir, HitLocation, HitNormal;
	local bool		bInstantHit;
	local rotator	BaseAimRot;

	bInstantHit = ( W == None || W.bInstantHit );
	BaseAimRot = (ControlModule != None) ? ControlModule.GetBaseAimRotation(StartFireLoc) : Rotation;

	//FireDir	= vector(BaseAimRot);
	//HitActor = Trace(HitLocation, HitNormal, StartFireLoc + W.GetTraceRange() * FireDir, StartFireLoc, true);

	/*HitEnemy = MSPawn(HitActor);
	if(HitEnemy != none )
	{
		
		LocationOffset = HitEnemy.Location - Pawn.Location;
		HeightOffset = RadToUnrRot * Atan2((HitEnemy.CylinderComponent.CollisionHeight - Pawn.CylinderComponent.CollisionHeight)/2.0,
			sqrt(LocationOffset.X * LocationOffset.X + LocationOffset.Y * LocationOffset.Y));

		BaseAimRot.Pitch = HeightOffset;
	}
	else*/ BaseAimRot.Pitch = 0;

    if ( !AimingHelp(bInstantHit) )
	{
    	return BaseAimRot;
	}
}

/* GetPlayerViewPoint: Returns Player's Point of View
   For the AI this means the Pawn's Eyes ViewPoint
   For a Human player, this means the Camera's ViewPoint */
simulated event GetPlayerViewPoint( out vector POVLocation, out Rotator POVRotation )
{
   local float DeltaTime;
   local UTPawn P;

   P = IsLocalPlayerController() ? UTPawn(CalcViewActor) : None;

   if (LastCameraTimeStamp == WorldInfo.TimeSeconds
      && CalcViewActor == ViewTarget
      && CalcViewActor != None
      && CalcViewActor.Location == CalcViewActorLocation
      && CalcViewActor.Rotation == CalcViewActorRotation
      )
   {
      if ( (P == None) || ((P.EyeHeight == CalcEyeHeight) && (P.WalkBob == CalcWalkBob)) )
      {
         // use cached result
         POVLocation = CalcViewLocation;
         POVRotation = CalcViewRotation;
         return;
      }
   }

   DeltaTime = WorldInfo.TimeSeconds - LastCameraTimeStamp;
   LastCameraTimeStamp = WorldInfo.TimeSeconds;

   // support for using CameraActor views
   if ( CameraActor(ViewTarget) != None )
   {
      if ( PlayerCamera == None )
      {
         super.ResetCameraMode();
         SpawnCamera();
      }
      super.GetPlayerViewPoint( POVLocation, POVRotation );
   }
   else
   {
      //do not destroy our camera!!!
      /* if ( PlayerCamera != None )
      {
         PlayerCamera.Destroy();
         PlayerCamera = None;
      } */

      //no camera, we have view target - let view target be in control
      if ( PlayerCamera == None && ViewTarget != None )
      {
         POVRotation = Rotation;
         if ( (PlayerReplicationInfo != None) && PlayerReplicationInfo.bOnlySpectator && (UTVehicle(ViewTarget) != None) )
         {
            UTVehicle(ViewTarget).bSpectatedView = true;
            ViewTarget.CalcCamera( DeltaTime, POVLocation, POVRotation, FOVAngle );
            UTVehicle(ViewTarget).bSpectatedView = false;
         }
         else
         {
            ViewTarget.CalcCamera( DeltaTime, POVLocation, POVRotation, FOVAngle );
         }

         if ( bFreeCamera )
         {
            POVRotation = Rotation;
         }
      }
      //no camera, no view target - we are in control
      else if(PlayerCamera == None)
      {
         CalcCamera( DeltaTime, POVLocation, POVRotation, FOVAngle );
         return;
      }
      //we have a camera - let camera be in control
      else
      {
         POVLocation = PlayerCamera.ViewTarget.POV.Location;
         POVRotation = PlayerCamera.ViewTarget.POV.Rotation;
         FOVAngle = PlayerCamera.ViewTarget.POV.FOV;
      }
   }

   // apply view shake
   POVRotation = Normalize(POVRotation + ShakeRot);
   POVLocation += ShakeOffset >> Rotation;

   if( CameraEffect != none )
   {
      CameraEffect.UpdateLocation(POVLocation, POVRotation, GetFOVAngle());
   }

   // cache result
   CalcViewActor = ViewTarget;
   CalcViewActorLocation = ViewTarget.Location;
   CalcViewActorRotation = ViewTarget.Rotation;
   CalcViewLocation = POVLocation;
   CalcViewRotation = POVRotation;

   if ( P != None )
   {
      CalcEyeHeight = P.EyeHeight;
      CalcWalkBob = P.WalkBob;
   }
}

defaultproperties
{
   CameraClass=class'MSGame.MSPlayerCamera'
	CharacterClass=class'MSGame.MSPlayerCharacterInfo'
   MatineeCameraClass=class'MSGame.MSPlayerCamera'
	InputClass=class'MSPlayerInput'
}
