
(
SynthDef.new(\threeTones, {
	arg freq = 100, freqWait = 10, lag = 2, out = 0, gate = 1;
	var env = EnvGen.ar(Env([0, 0.2, 0], [1, 1], releaseNode: 1), gate: gate, doneAction: Done.freeSelf);
	var sig = SinOsc.ar(Lag.kr(freq, lag)) * env;
	Out.ar(out, sig);
}).add;

~worms = { arg index = 0, melody =
	(
		freqs: [
			[100, 150, 120],
			[200, 180, 220],
			[300, 310, 260]
		],
		durs: [4, 4, 4]
	);

	p = Pmono(
		\threeTones,
		\dur, Pseq(melody[\durs], inf),
		\freq, Pseq(melody[\freqs].flop, 2),
		\timingOffset, Pkey(\dur) * Pwhite(-0.5!3, 0.5!3),
		\lag, Pwhite(2, 2, inf),
		\gate, 1,
		\out, ~instBusses[index],
		\group, ~instGroups[index],
		\addAction, \addToHead,
		\index, index,
		\callback, ~updateView
	).play;
}
)
