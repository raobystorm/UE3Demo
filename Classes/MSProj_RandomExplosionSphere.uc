class MSProj_RandomExplosionSphere extends MSProj_PurpleBarrageWeak;

var int FireLevel;

function BlowUp()
{
	Explode(Location, -1 * Normal(Velocity));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
	if ( !bShuttingDown )
	{
		ProjectileHurtRadius(HitLocation, HitNormal );
	}
	SplitProjectile();

	SpawnExplosionEffects(HitLocation, HitNormal);

	ShutDown();
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=100
		CollisionHeight=100
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_ExplosionSphere'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_ExplosionSphere_Impact'
	MaxEffectDistance=4096.0

	Speed=0
	MaxSpeed=0
	AccelRate=0
	bBlockedByInstigator=true

	bNeedUpdateRotation=false

	FireLevel=1

	TimerCount=1
	TimerDelay=1.5
	Timer=BlowUp

	SplitInterval=0
	SplitCount=0

	Damage=350
	DamageRadius=650
	MomentumTransfer=300000
	CheckRadius=650

	MyDamageType=class'UTDmgType_Burning'
	LifeSpan=4.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=3

	ExplosionSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_ComboExplosionCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}