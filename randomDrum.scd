(
SynthDef(\randomDrum, {
	arg freq = 100, out = 0;
	var env = EnvGen.ar(Env.perc(0.004, 0.5, 0.33), gate: Dust.ar(1.1));

	Out.ar(
		out,
		SinOsc.ar(freq) * env
	);
}).add;

~randomDrum = { arg index = 0, melody =
	(
		freqs: [
			[100, 110, 120],
			[200, 210, 220],
			[400, 500, 600]
		],
		durs: [4, 4, 4]
	);

	p = Pmono(
		\randomDrum,
		\dur, Pseq(melody[\durs], inf),
		\sustain, Pkey(\dur),
		\freq, Pseq(melody[\freqs].flop, inf),
		\out, ~instBusses[index],
		\group, ~instGroups[index],
		\addAction, \addToHead,
		\index, index,
		\callback, ~updateView
	).play;
}
)
