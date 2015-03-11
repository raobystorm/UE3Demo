class MSProj_RedBallMiddle extends MSProj_PurpleBarrageWeak;

function ResetAccel()
{
	Acceleration = vect(0,0,0);
	AccelRate = 0;
}

DefaultProperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=20
		CollisionHeight=20
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder 

	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_RedBallMiddle'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_RedBallMiddle_Impact'
	MaxEffectDistance=4096.0

	
	Speed=3000
	MaxSpeed=0
	AccelRate=-5500
	bBlockedByInstigator=true

	TimerCount=1
	TimerDelay=0.45
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
