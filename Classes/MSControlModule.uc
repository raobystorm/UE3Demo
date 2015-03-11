class MSControlModule extends Object
   abstract
   config(Control);
   
//reference to the owning controller
var MSPlayerController Controller;

//mode-specific initialization
function Init();

/** Called when the camera becomes active */
function OnBecomeActive( MSControlModule OldModule );
/** Called when the camera becomes inactive */
function OnBecomeInActive( MSControlModule NewModule );

//Calculate Pawn aim rotation
simulated singular function Rotator GetBaseAimRotation(Vector StartFireLoc);

//Handle custom player movement
function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

function ProcessMoveInWater(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

//Calculate controller rotation
function UpdateRotation(float DeltaTime);

defaultproperties
{
}
