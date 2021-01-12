
(
var getFreq = Pwhite(50, 175, inf);
var getLag = Pwhite(2, 2, inf);
var getWait = Pwhite(4, 8, inf);
var threeTonesInstance;

SynthDef.new(\threeTones, {
	arg freq1 = 100, freq2 = 200, freq3 = 300, lag = 2, out = 0, gate = 1;

	var getFreqOut = {|freq| Lag.kr(freq, lag)};
	var freqOut1 = getFreqOut.value(freq1);
	var freqOut2 = getFreqOut.value(freq2);
	var freqOut3 = getFreqOut.value(freq3);
	var env = EnvGen.ar(
		Env(
			levels: [0, 0.6, 0.2, 0],
			times: [0.005, 0.5, 1],
			curve:[0, -4, 0],
			releaseNode: 2
		),
		gate: gate,
		doneAction: Done.freeSelf
	);
	Out.ar(
		out,
		Mix([
			SinOsc.ar(freqOut1),
			SinOsc.ar(freqOut2),
			SinOsc.ar(freqOut3)
		])!2 * env
	);
}).add;

//freq arg doesn't do anything yet
~sustains = { arg out, target, freq;

	p = Pbind(
		\instrument, \threeTones,
		\args, Prand(#[[\freq1], [\freq2], [\freq3]], inf),
		\dur, getWait.trace,
		\freq1, getFreq.trace,
		\freq2, getFreq.trace,
		\freq3, getFreq.trace,
		\lag, getLag.trace,
		\sustain, Pkey(\dur) * Pwhite(0.0, 1.0, inf),
		\gate, 1,
	).play;
}
)


x = ~sustains.value;