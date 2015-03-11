
class MSEmitterSpawnable extends EmitterSpawnable;

/** Light from the Emitter */
var(MahoShojo) PointLightComponent MyPointLightComponent;
/** How long the light should stay in existance, if enabled. 
 *  Zero keeps it active for the entire lifetime of the emitter. */
var(MahoShojo) float LightLifeSpan;
/** How long after spawning the Light should take to interpolate up to full brightness. */
var(MahoShojo) float LightFadeUpTime;
/** How long BEFORE lifespan expires the Light should take to interpolate down to zero brightness. */
var(MahoShojo) float LightFadeOutTime;
/** A list of cues, one randomly chosen from, to play when this emitter spawns. */
var(MahoShojo) array<SoundCue> RandomSoundToPlay;
/** The audio component of the Emitter. */
var(MahoShojo) AudioComponent MyAudioComponent;
/** Whether the Emitter should stay alive until the sound is finished playing (in case the sound is longer than thee particle effect). 
 *  DO NOT use for Looping sound or the emitter will never die! */
var(MahoShojo) bool AllowSoundToFinishBeforeDestroying;

var float OriginalBrightness;
var float FadeOutStartTime;
var bool DoLightFadeDown;
var bool DoLightFadeUp;

simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
	//if not already fading down, start the fade down
	if(!DoLightFadeDown)
	{
		DoLightFadeDown=true;
		FadeOutStartTime = WorldInfo.TimeSeconds;
		if(MyAudioComponent.IsPlaying() && !AllowSoundToFinishBeforeDestroying)
			MyAudioComponent.FadeOut(LightFadeOutTime,0);
	}

	//stay alive just long enough to completely fade-out our light
	LifeSpan = FMax(LightFadeOutTime,LightLifeSpan) + 0.1;

	bCurrentlyActive = false;
}

/** Force deactivation of the emitter, its sound, and fade-out of its light over an optionally-specified time. */
function FadeOut(optional float theLightFadeOutTime)
{
	if(!DoLightFadeDown)
	{
		DoLightFadeUp=false;
		DoLightFadeDown=true;
		FadeOutStartTime = WorldInfo.TimeSeconds;
		if(theLightFadeOutTime > 0)
			LightFadeOutTime = theLightFadeOutTime;
		if(MyAudioComponent.IsPlaying() && !AllowSoundToFinishBeforeDestroying)
			MyAudioComponent.FadeOut(LightFadeOutTime,0);
		LifeSpan = 3;
	}

	ParticleSystemComponent.DeactivateSystem();
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	//start fading light up immediately upon spawning
	OriginalBrightness = MyPointLightComponent.Brightness;
	DoLightFadeUp=true;
	if(RandomSoundToPlay.Length > 0)
	{
		MyAudioComponent.SoundCue = RandomSoundToPlay[Rand(RandomSoundToPlay.Length)];
		MyAudioComponent.Play();
	}
}

function SetSize(float size)
{
	MyPointLightComponent.Radius *= size/DrawScale;
	SetDrawScale(size);
}

event Tick(float DeltaTime)
{
	local float percentage;

	super.Tick(DeltaTime);

	//if the light is enabled, logic associated with fading up and fading down
	if(MyPointLightComponent.bEnabled)
	{
		//if we're not yet fading down, but we have a light lifespan, decrement it...
		if(LightLifeSpan > 0 && !DoLightFadeDown)
		{
			LightLifeSpan-=DeltaTime;
			//and see if we should start fading down, if we're past that point.
			if(LightLifeSpan <= LightFadeOutTime)
			{
				DoLightFadeUp=false;
				DoLightFadeDown=true;
				FadeOutStartTime = WorldInfo.TimeSeconds;
				if(MyAudioComponent.IsPlaying() && !AllowSoundToFinishBeforeDestroying)
					MyAudioComponent.FadeOut(LightFadeOutTime,0);
			}
		}

		//if we're fading up, lerp the brightness up until we're finished fading up
		if(DoLightFadeUp)
		{
			percentage = FMin(`TimeSince(CreationTime)/LightFadeUpTime,1);
			if(percentage == 1)
				DoLightFadeUp=false;

			MyPointLightComponent.SetLightProperties(OriginalBrightness*percentage);
		}

		//if we're fading down, lerp the brightness down until we're finished fading down
		if(DoLightFadeDown)
		{		
			percentage = FMin(`TimeSince(FadeOutStartTime)/LightFadeOutTime,1);
			if(percentage == 1)
			{
				DoLightFadeDown=false;
				MyPointLightComponent.SetEnabled(false);
			}
			
			MyPointLightComponent.SetLightProperties(OriginalBrightness*(1.0 - percentage));
		}
	}
}

DefaultProperties
{
	Begin Object Class=PointLightComponent Name=PointLightComponent0
		LightAffectsClassification=LAC_DYNAMIC_AND_STATIC_AFFECTING
	    CastShadows=FALSE
	    CastStaticShadows=FALSE
	    CastDynamicShadows=FALSE
	    bForceDynamicLight=TRUE
	    UseDirectLightMap=FALSE
	    LightingChannels=(BSP=TRUE,Static=TRUE,Dynamic=TRUE,bInitialized=TRUE)
	    Brightness = 1.0;
		LightColor=(R=255,G=255,B=255)
		Radius=500
		bEnabled=false
	End Object
	Components.Add(PointLightComponent0)
	MyPointLightComponent=PointLightComponent0

	Begin Object Class=AudioComponent Name=AudioComponent0
	End Object
	Components.Add(AudioComponent0)
	MyAudioComponent=AudioComponent0

	bDestroyOnSystemFinish=true
	LightFadeUpTime = 0.1
	LightFadeOutTime = 0.1
	AllowSoundToFinishBeforeDestroying=true
}