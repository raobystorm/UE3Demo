class MSFirePowerSmall extends MSInventory;

var int FirePowerContained;
var int HealthContained;

function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
	local MSPlayer P;

	P = MSPlayer(NewOwner);
	if (P != None)
	{
		P.CurrentFirePower = Min( P.CurrentFirePower + FirePowerContained, P.MaxFirePower);
		P.Health = Min(P.Health + HealthContained, P.HealthMax);
	}
	Destroy();
}

DefaultProperties
{
	FirePowerContained=20
	HealthContained=15
}
