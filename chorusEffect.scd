
(
/**
* @param baseFreq - base frequency for the held tone
* defaults to 110
*
* @param centsAway - number of cents away from the base frequency to shift the pitch to
* defaults to 0
*
* @param amp - amplitude of wave
* defaults to 0.1
*/
var voice = {
	arg baseFreq = 110,
	centsAway = 0,
	amp = 0.1;
	var finalFreq = baseFreq * (2**(centsAway/1200));
	{
		SinOsc.ar(freq: finalFreq, mul: amp)!2
	}
};
voice.value(baseFreq: 110, centsAway: 0, amp: 0.7).play;
voice.value(baseFreq: 110, centsAway: 1).play;
voice.value(baseFreq: 110, centsAway: 2).play;
voice.value(baseFreq: 110, centsAway: 3).play;

voice.value(baseFreq: 260, centsAway: 0).play;
voice.value(baseFreq: 260, centsAway: -10).play;
voice.value(baseFreq: 260, centsAway: -9).play;
voice.value(baseFreq: 260, centsAway: 3).play;
)


//this is a new line

//another new line
