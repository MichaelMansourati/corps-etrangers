/*
this function "neighbourToneSineWave"  creates a sine wave that steps between two pitches,
the first being "startFrequency", and the second being "startFrequency + (startFrequency * upperStepRatio)
at a steady rate as determined by the "cycleLengthInSeconds".

the amplitude of the wave can be controlled with the "amplitude" arg as well.

start with the volume low, as it's a bit of sharp attack when all the sine waves start together ;)
*/

(
var neighbourToneSineWave = {
	//parameters with their default values
	arg startFrequency = 110,
	amplitude = 1,
	upperStepRatio = 1/9,
	cycleLengthInSeconds = 1;

	//this will plot the shape of the square waves used to modulate their respective sine waves
	//over a period of 4 seconds
	//feel free to modify it or comment it out as you wish
	{
		LFPulse.ar(
			freq: 1 / cycleLengthInSeconds,
			mul: upperStepRatio,
			width: 0.5,
			add: 1,
			iphase: 0.5
		)
	}.plot(4);

	//this is the Sine wave you're hearing, where the frequency is modified by the numeric output of a square wave
	{
		SinOsc.ar(
			freq: startFrequency * LFPulse.ar(
				freq: 1 / (cycleLengthInSeconds * 2),
				mul: upperStepRatio,
				width: 0.5,
				add: 1,
				iphase: 0.5
			),
			mul: amplitude
		)!2
	}
};

//function calls (to be played around with)
neighbourToneSineWave.value(
	startFrequency: 220,
	amplitude: 0.3,
	upperStepRatio: 1/3,
	cycleLengthInSeconds: 1.3
).play;

neighbourToneSineWave.value(
	startFrequency: 110 * 5/4,
	amplitude: 0.7,
	upperStepRatio: 2/15,
	cycleLengthInSeconds: 1.2
).play;

neighbourToneSineWave.value(
	startFrequency: 110,
	// amplitude: 1,
	upperStepRatio: 1/9,
	cycleLengthInSeconds: 2
).play;

)