(
/*
this function creates a sineWave that steps between two pitches,
the first being "startFrequency", and the second being "startFrequency + (startFrequency * upperStepRatio)

*/
var neighbourToneSineWave = {
	arg startFrequency = 110,
	amplitude = 1,
	upperStepRatio = 1/9,
	phaseLengthInSeconds = 1;

	{
		LFPulse.ar(
			freq: 1 / (phaseLengthInSeconds * 2),
			mul: upperStepRatio,
			width: 0.5,
			add: 1,
			iphase: 0.5
		)
	}.plot(4);

	{
		SinOsc.ar(
			freq: startFrequency * LFPulse.ar(
				freq: 1 / (phaseLengthInSeconds * 2),
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
	phaseLengthInSeconds: 1.3
).play;

neighbourToneSineWave.value(
	startFrequency: 110 * 5/4,
	amplitude: 0.7,
	upperStepRatio: 2/15,
	phaseLengthInSeconds: 1.2
).play;

neighbourToneSineWave.value(
	startFrequency: 110,
	amplitude: 1,
	upperStepRatio: 1/9,
	phaseLengthInSeconds: 2
).play;

)