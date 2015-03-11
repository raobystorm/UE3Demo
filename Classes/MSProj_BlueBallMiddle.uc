class MSProj_BlueBallMiddle extends MSProj_PurpleBarrageWeak;

function ResetAccel()
{
	LocalAcceleration = Vect(-2000, -250, 0);
	Acceleration = LocalAcceleration >> Rotation;
	AccelRate = 0;
}

defaultproperties
{
	
	Begin Object Name=CollisionCylinder
		CollisionRadius=20
		CollisionHeight=20
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BlueBallMiddle'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BlueBallMiddle_Impact'
	MaxEffectDistance=4096.0

	Speed=700
	AccelRate=0
	MaxSpeed=9000
	bNeedUpdateRotation=false
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=0.5
	Timer=ResetAccel

	Damage=30
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=20

	MyDamageType=class'UTDmgType_Lava'
	LifeSpan=5.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.3

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=0.7,Y=0.7,Z=1.5)
	ExplosionColor=(X=0.7,Y=0.7,Z=1.5);
}