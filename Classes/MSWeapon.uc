/*
 *  Main weapon class for project Mahoshojo!
 *  Override much weapon logic of the game
 * */

class MSWeapon extends UTWeapon;

// Weapon fire strength control
var int CurrentFireLevel;
var int FireLevelGap;
var float FireCheckFrequence;
var float CheckTime;

// This is the offset when the projectiles need to spawn at the different location
var Vector ProjectileSpawnOffset;

var repnotify class<Inventory> DroppedInventoryClass;

enum EWeaponFireType
{
	EWFT_InstantHit,
	EWFT_Projectile,
	EWFT_MultiProjectile,
	EWFT_Custom,
	EWFT_None
};

var				Array<EWeaponFireType>		WeaponFireTypes;

simulated function FireAmmunition()
{
	// Use ammunition to fire
	// ConsumeAmmo( CurrentFireMode );

	// Handle the different fire types
	PlayFiringSound();

	switch( WeaponFireTypes[CurrentFireMode] )
	{
		case EWFT_InstantHit:
			InstantFire();
			break;

		case EWFT_Projectile:
			ProjectileFire();
			break;

		case EWFT_MultiProjectile:
			MultiProjectileFire();
			break;

		case EWFT_Custom:
			CustomFire();
			break;
	}

	NotifyWeaponFired( CurrentFireMode );

	if (UTPawn(Instigator) != None)
	{
		UTPawn(Instigator).DeactivateSpawnProtection();
	}

	UTInventoryManager(InvManager).OwnerEvent('FiredWeapon');

}

simulated function Array<Projectile> MultiProjectileFire()
{
	local vector		RealStartLoc;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		RealStartLoc = GetPhysicalFireStartLoc();

		// Return it up the line
		return SpawnMultiProjectiles( RealStartLoc);
	}
}

simulated function array<Projectile> SpawnMultiProjectiles( vector RealStartLoc);


function DropFrom(vector StartLocation, vector StartVelocity)
{
	local DroppedPickup P;

	if (Instigator != None && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
	{
		PreloadTextures(false);
	}

	if( !CanThrow() )
	{
		return;
	}

	// Become inactive
	GotoState('Inactive');

	// Stop Firing
	ForceEndFire();
	// Detach weapon components from instigator
	DetachWeapon();

	if( Instigator != None && Instigator.InvManager != None )
	{
		Instigator.InvManager.RemoveFromInventory(Self);
	}

	// if cannot spawn a pickup, then destroy and quit
	if( DroppedPickupClass == None || DroppedPickupMesh == None )
	{
		Destroy();
		return;
	}

	P = Spawn(DroppedPickupClass,,, StartLocation);

	if( P == None )
	{
		Destroy();
		return;
	}

	P.SetPhysics(PHYS_Falling);
	P.InventoryClass = DroppedInventoryClass;
	P.Velocity = StartVelocity;
	P.Inventory = Spawn(DroppedInventoryClass,,, StartLocation);
	P.Instigator = Instigator;
	P.SetPickupMesh(DroppedPickupMesh);
	P.SetPickupParticles(DroppedPickupParticles);

	Instigator = None;
	GotoState('');

	AIController = None;

}

simulated function vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	local UTPlayerController PC;
	local vector FireStartLoc;
	local rotator FireRot;

	if( Instigator != none )
	{
		PC = UTPlayerController(Instigator.Controller);

		FireRot = Instigator.GetViewRotation();
		if (PC == none || PC.bCenteredWeaponFire || PC.WeaponHand == HAND_Centered || PC.WeaponHand == HAND_Hidden)
		{
			FireStartLoc = Instigator.GetPawnViewLocation() + TransformVectorByRotation(FireRot, FireOffset);
		}
		else
		{
			FireStartLoc = Instigator.GetPawnViewLocation() + TransformVectorByRotation(FireRot, FireOffset);
		}

		/*if ( (PC != None) || (CustomTimeDilation < 1.0) )
		{
			FiredProjectileClass = GetProjectileClass();
			if ( FiredProjectileClass != None )
			{
				FireEnd = FireStartLoc + FireDir * ProjectileSpawnOffset;
				TraceFlags = bCollideComplex ? TRACEFLAG_Bullet : 0;
				if ( FiredProjectileClass.default.CylinderComponent.CollisionRadius > 0 )
				{
					FireEnd += FireDir * FiredProjectileClass.default.CylinderComponent.Translation.X;
					ProjBox = FiredProjectileClass.default.CylinderComponent.CollisionRadius * vect(1,1,0);
					ProjBox.Z = FiredProjectileClass.default.CylinderComponent.CollisionHeight;
					HitActor = Trace(HitLocation, HitNormal, FireEnd, Instigator.Location, true, ProjBox,,TraceFlags);
					if ( HitActor == None )
					{
						HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, ProjBox,,TraceFlags);
					}
					else
					{
						FireStartLoc = Instigator.Location - FireDir*FiredProjectileClass.default.CylinderComponent.Translation.X;
						FireStartLoc.Z = FireStartLoc.Z + FMin(Instigator.EyeHeight, Instigator.CylinderComponent.CollisionHeight - FiredProjectileClass.default.CylinderComponent.CollisionHeight - 1.0);
						return FireStartLoc;
					}
				}
				else
				{
					HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, vect(0,0,0),,TraceFlags);
				}
				return (HitActor == None) ? FireEnd : HitLocation - 3*FireDir;
			}
		}*/
		return FireStartLoc;
	}
	return Location;
}

state Active
{
	simulated event Tick(float DeltaTime)
	{
		local MSPawn OwnerPawn;
		local MSPlayerController Controller;

		if(CheckTime <= 0.0)
		{
			CheckTime = FireCheckFrequence;
			OwnerPawn = MSPawn(Owner);
			Controller = MSPlayerController(OwnerPawn.Controller);
			if(OwnerPawn != none && Controller != none)
			{
				CurrentFireLevel = 1 + OwnerPawn.CurrentFirePower / FireLevelGap;
			}
		}
		else CheckTime -= DeltaTime;
		super.Tick(DeltaTime);
	}
}

DefaultProperties
{
	CheckTime=1.0
	CurrentFireLevel=1
	FireLevelGap=40
	FireCheckFrequence=1.0
	ProjectileSpawnOffset=(X=0,Y=0,Z=0)
}
