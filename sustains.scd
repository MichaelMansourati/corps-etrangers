
(
var getFreq = Pwhite(50, 175, inf);
var getLag = Pwhite(2, 2, inf);
var getWait = Pwhite(4, 8, inf);
var threeTonesInstance;

SynthDef.new(\threeTones, {
	arg freq1 = 100, freq2 = 200, freq3 = 300, out = 0, gate = 1;

	var env = EnvGen.ar(
		Env(
			levels: [0, 0.7, 0.2, 0],
			times: [0.01, 0.75, 1],
			curve:[0, -4, 0],
			releaseNode: 2
		),
		gate: gate,
		doneAction: Done.freeSelf
	);
	Out.ar(
		out,
		Mix([
			SinOsc.ar(freq1),
			SinOsc.ar(freq2),
			SinOsc.ar(freq3)
		])!2 * env
	);
}).add;

//freq arg doesn't do anything yet
~sustains = { arg out, target, freq;

	p = Pbind(
		\instrument, \threeTones,
		\args, Prand(#[[\freq1], [\freq2], [\freq3]], inf),
		\dur, getWait,
		\freq1, getFreq,
		\freq2, getFreq,
		\freq3, getFreq,
		\sustain, Pkey(\dur) * Pwhite(0.0, 0.9, inf).trace,
		\gate, 1,
	).play;
}
)

x = ~sustains.value;

