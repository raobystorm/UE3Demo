class MSHUD extends HUD;

// The texture which represents the cursor on the screen
var const Texture2D CursorTexture; 
// The color of the cursor
var const Color CursorColor;

var Vector MouseProjectionDirection;
var Vector MouseProjectionOrigin; 
var Vector MouseProjectionLocation;

var Font PlayerFont;
var float PlayerNameScale;
var float NameHeight;
var MSPawn MouseTarget;

function Vector GetMouseWorldLocation()
{
	local MSPlayerInput MSPlayerInput;
	local Vector2D MousePosition;
	local Vector HitLocation, HitNormal;

	MouseTarget = none;

	if(Canvas == none || PlayerOwner == None)
	{
		return Vect(0, 0, 0);
	}

	// Get the input instance;
	MSPlayerInput  = MSPlayerInput( PlayerOwner.PlayerInput);

	if(MSPlayerInput == None)
	{
		return Vect(0, 0, 0);
	}

	// Get the mouse position on the screen
	MousePosition.X = MSPlayerInput.MousePosition.X;
	MousePosition.Y = MSPlayerInput.MousePosition.Y;

	// Canvas deprojection function to get the location
	Canvas.DeProject( MousePosition, MouseProjectionOrigin, MouseProjectionDirection);
	MouseTarget = MSPawn(Trace( HitLocation, HitNormal, MouseProjectionOrigin + MouseProjectionDirection * 65536.f, MouseProjectionOrigin, true, , , TRACEFLAG_Bullet));

	return HitLocation;
}

function DrawHUD()
{	
	local MSPlayerInput MSPlayerInput;
	local Vector2D TextSize;
	local MSPlayer Pawn;
	local String HP, FP, STM;

	Pawn = MSPlayer(PlayerOwner.Pawn);
	super.DrawHUD();

	HP = "Health:" @ Pawn.Health;
	FP = "Power:" @ Pawn.CurrentFirePower;
	STM = "Stamina:" @ int(Pawn.Stamina);
   
   //Draw Player health
   Canvas.Font = PlayerFont;
   Canvas.SetDrawColor(255, 50, 50, 255);
   Canvas.SetPos(10, SizeY - 100);
   Canvas.DrawText(HP,false,PlayerNameScale / RatioX,PlayerNameScale / RatioY);

   if(Pawn != none)
   {
		Canvas.SetDrawColorStruct(ConsoleColor);
		Canvas.StrLen(FP, TextSize.X, TextSize.Y);
		Canvas.SetPos(10, SizeY - 80);
		Canvas.DrawText(FP,false,PlayerNameScale / RatioX,PlayerNameScale / RatioY);

		Canvas.SetDrawColorStruct(ConsoleColor);
		Canvas.StrLen(STM, TextSize.X, TextSize.Y);
		Canvas.SetPos(10, SizeY - 60);
		Canvas.DrawText(STM,false,PlayerNameScale / RatioX,PlayerNameScale / RatioY);
   }


	// Draw mouse and update its location in the world
	if (PlayerOwner != None && CursorTexture != None) 
	{
	// Cast to get the MouseInterfacePlayerInput
	MSPlayerInput = MSPlayerInput(PlayerOwner.PlayerInput); 

		if (MSPlayerInput != None)
		{
			Canvas.SetPos(MSPlayerInput.MousePosition.X, MSPlayerInput.MousePosition.Y); 
			Canvas.DrawColor = CursorColor;
			Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
		}
	}
  
	MouseProjectionLocation = GetMouseWorldLocation();
}

function bool IsOnRightOfCanvas(Vector2d screenPos, float percentFromEdge)
{
	return screenPos.X > SizeX-percentFromEdge*SizeX;
}

function float GetHUDAspectRatio()
{
	if(SizeY > 0)
		return SizeX/SizeY;
	else
		return 0;
}

function SetMousePosCenter()
{
	if(MSPlayerInput(PlayerOwner.PlayerInput) != none) 
		MSPlayerInput(PlayerOwner.PlayerInput).SetMousePos(CenterX, CenterY);
}

function bool IsOnCanvas(Vector screenPos, float width, float height)
{
	return !(screenPos.X < Canvas.OrgX-width/2 || screenPos.Y < Canvas.OrgY-height/2 || screenPos.X > Canvas.ClipX+width/2 || screenPos.Y > Canvas.ClipY+height/2);
}

function bool IsOnLeftOfCanvas(Vector2d screenPos, float percentFromEdge)
{
	return screenPos.X < percentFromEdge*SizeX;
}

function bool IsOnTopOfCanvas(Vector2d screenPos, float percentFromEdge)
{
	return screenPos.Y < percentFromEdge*SizeY;
}

function bool IsOnBottomOfCanvas(Vector2d screenPos, float percentFromEdge)
{
	return screenPos.Y > SizeY - percentFromEdge*SizeY;
}

function vector2D GetMouseCoordinates()
{
	local Vector2D mousePos;
	local MSPlayerInput MSPlayerInput;
	if( PlayerOwner != None)
	{
		MSPlayerInput = MSPlayerInput(PlayerOwner.PlayerInput);
		mousePos.X = MSPlayerInput.MousePosition.X;
		mousePos.Y = MSPlayerInput.MousePosition.Y;
		return mousePos;
	}
}

function vector GetMouseCoordinatesVec()
{
	local Vector mousePos;
	local MSPlayerInput MSPlayerInput;

	if( PlayerOwner != None)
	{
		MSPlayerInput = MSPlayerInput(PlayerOwner.PlayerInput);
		mousePos.X = MSPlayerInput.MousePosition.X;
		mousePos.Y = MSPlayerInput.MousePosition.Y;
		return mousePos;
	}
}

defaultproperties
{
	CursorColor=(R=255,G=255,B=255,A=255)
	CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
	//
	NameHeight=150
	PlayerFont="UI_Fonts.MultiFonts.MF_HudLarge"
	PlayerNameScale=0.13
}
