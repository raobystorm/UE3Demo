class MSProj_SpawnSphere extends MSProj_PurpleBarrageWeak;

// The direction of the child projectiles spawning to
var Vector SpawnAimLoc;
// The power level inherited from the weapon
// Affect the splitting projectiles
var int FireLevel;
// How many tails of children projectiles are there
var int SpawnTrailCount;

// Control the splitted projectiles' rot
var Rotator SplitBaseRot;
var Rotator SplitRot;
var Rotator SplitRotOffset;

function SplitProjectile()
{
	
	Acceleration = vect( 0, 0, 0);

	SplitBaseRot = Rotator( SpawnAimLoc - Location );

	SplitRotOffset.Pitch = 0;
	SplitRotOffset.Roll = 0;
	SplitRotOffset.Yaw = DegToUnrRot * 3;

	SpawnTrailCount = DegToUnrRot * 25 / SplitRotOffset.Yaw;

 	SplitBaseRot -=  (SpawnTrailCount/2 + 0.5) * SplitRotOffset;

	SpawnSmallProjectiles();
}

function SpawnSmallProjectiles()
{
	local int SpawnTrail;
	local MSProj_BlueBarrageRapid BlueProj;
	local MSProj_RedBarrageRapid RedProj;

	// Select a random trail to spawn the projectile
	SpawnTrail = Rand(SpawnTrailCount);
	SplitRot = SplitBaseRot + SplitRotOffset * SpawnTrail;

	// Random decide to spawn blue projectile or red projectile
	if( Rand(2) == 0)
	{
		// Spawn blue here
		BlueProj = Spawn(class'MSProj_BlueBarrageRapid' ,,, Location);
		BlueProj.Init(Vector(SplitRot));
	}
	else 
	{
		RedProj = Spawn(class'MSProj_RedBarrageRapid' ,,, Location);
		RedProj.Init(Vector(SplitRot));
	}

	SplitCount--;
	SetTimer(SplitInterval, false, 'SpawnSmallProjectiles');

}

simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;

	TriggerEventClass(class'SeqEvent_HitWall', Wall);

	if ( Wall.bWorldGeometry )
	{ 
		HitStaticMesh = StaticMeshComponent(WallComp);
        if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
        {
	        NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
	        if ( NewKActor != None )
			{
				Wall = NewKActor;
			}
        }
	}
	ImpactedActor = Wall;
	if ( !Wall.bStatic && (DamageRadius == 0) )
	{
		Wall.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
	}

	Velocity = vect(0, 0, 0);
	ImpactedActor = None;
}

simulated function ProcessTouch (Actor Other, vector HitLocation, vector HitNormal)
{
	local MSPawn HitPawn;

	HitPawn = MSPawn(Other);
	if(HitPawn != none)
	{
		// If we hit a pawn and this pawn is not a player, then we do not explode
		if(MSPlayerController(HitPawn.Controller) == none) return;

		// When we hit the player, we could do some extra works here
		if ( Role == ROLE_Authority )
			MakeNoise(1.0);
		if( !bShuttingDown )
		{
			ProjectileHurtRadius(HitLocation, HitNormal);
		}
	}
	else
	{
		Velocity = Vect(0, 0, 0);
	}
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=70
		CollisionHeight=70
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_SpawnSphere'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_SpawnSphere_Impact'
	MaxEffectDistance=4096.0

	Speed=600
	MaxSpeed=0
	AccelRate=-300
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=2.0
	Timer=SplitProjectile

	SplitChildrenClass=class'MSProj_RedBarrageSmall'
	SplitCount=50
	SplitInterval=0.05

	Damage=80
	DamageRadius=70
	MomentumTransfer=0
	CheckRadius=70

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=12.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.3

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}