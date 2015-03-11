class MSFireVolume extends DynamicPhysicsVolume
	showcategories(Movement)
	placeable;

function CausePainTo(Actor Other)
{
	local MSBoss Boss;

	Boss = MSBoss(Other);
	if(Boss != none)
	{
		return;
	}

	if (DamagePerSec > 0)
	{
		if ( WorldInfo.bSoftKillZ && (Other.Physics != PHYS_Walking) )
			return;
		if ( (DamageType == None) || (DamageType == class'DamageType') )
			`log("No valid damagetype ("$DamageType$") specified for "$PathName(self));
		Other.TakeDamage(DamagePerSec*PainInterval, DamageInstigator, Location, vect(0,0,0), DamageType,, self);
	}
	else
	{
		Other.HealDamage(-DamagePerSec * PainInterval, DamageInstigator, DamageType);
	}
}

DefaultProperties
{
}
