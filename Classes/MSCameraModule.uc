class MSCameraModule extends Object
   abstract
   config(Camera);

//owning camera
var transient MSPlayerCamera   PlayerCamera;
var float CameraCollisionOffset;
var(MahoShojo) float CamSpinSpeed;
var(MahoShojo) float CamRollSpeed;

//mode-specific initialization
function Init();

/** Called when the camera becomes active */
function OnBecomeActive( MSCameraModule OldCamera );
/** Called when the camera becomes inactive */
function OnBecomeInActive( MSCameraModule NewCamera );

//Calculate new camera location and rotation
function UpdateCamera(Pawn P, MSPlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT);

function SpinCamera(float amount, optional bool forcespin);

//Check and update the spin camera operation
function UpdateCameraSpin();

function StartSpinCameraLeft();

function StartSpinCameraRight();

function StopSpinCameraLeft();

function StopSpinCameraRight();

//Process the camera collision 
function ProcessCollision(Vector HitLocation, Vector HitNormal, Vector TargetLocation, TraceHitInfo HitInfo, float DeltaTime);

//initialize new view target
simulated function BecomeViewTarget( MSPlayerController PC );

//handle zooming in
function ZoomIn();

//handle zooming in
function ZoomOut();

defaultproperties
{
}
