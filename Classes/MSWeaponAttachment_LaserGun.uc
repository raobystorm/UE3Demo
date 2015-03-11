class MSWeaponAttachment_LaserGun extends UTWeaponAttachment;

defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
		Translation=(Z=1)
		Rotation=(Roll=-400)
		Scale=0.9
	End Object

	MuzzleFlashSocket=MussleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'Bounty.Particles.P_FX_LinkGun_3P_Primary_MF'
	MuzzleFlashAltPSCTemplate=ParticleSystem'Bounty.Particles.P_FX_LinkGun_3P_Primary_MF'
	MuzzleFlashColor=(R=255,G=255,B=255,A=255)
	MuzzleFlashDuration=0.33;
	MuzzleFlashLightClass=class'MSLaserGunMuzzleFlashLight'
	WeaponClass=class'MSBeamWeap_LaserGun'
	//ImpactLightClass=class'UTShockImpactLight'
}