class MSProj_YellowBarrageSmall extends MSProj_PurpleBarrageSmall;

function ResetAccel()
{
	Acceleration = Vect(0,-75,0) >> Rotation;
}

DefaultProperties
{
	ProjFlightTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase1_Yellow'
	ProjExplosionTemplate=ParticleSystem'Bounty.Particles.MSProj_BossPhase1_Yellow_Impact'
	LocalAcceleration=(X=-4800,Y=-75,Z=0)
}
