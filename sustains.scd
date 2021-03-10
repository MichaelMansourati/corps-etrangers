(
SynthDef(\sustains, {
	var env = Env(
		levels: [0, 0.3, 0.1, 0],
		times: [0.01, 0.75, 1],
		curve:[0, -4, 0],
		releaseNode: 2
	);
	SynthDef.wrap(
		{
			arg env, freq = 100, out = 0, gate = 1;

			var envLocal = EnvGen.ar(
				env,
				gate: gate,
				doneAction: Done.freeSelf
			);
			var sig = SinOsc.ar(freq) * envLocal;

			Out.ar(out, sig);
		},
		nil,
		[env]
	);
}).add;

~sustains = { arg index = 0, melody =
	(
		freqs: [
			[100, 110, 120],
			[160, 170, 180],
			[130, 140, 150]
		],
		durs: [5, 5, 5]
	);

	p = Pbind(
		\instrument, \sustains,
		\dur, Pseq(melody[\durs], 1),
		\freq, Pseq(melody[\freqs].flop, 1),
		\sustain, Pkey(\dur) * Pwhite(0.0, 0.9, inf),
		\gate, 1,
		\out, ~instBusses[index],
		\group, ~instGroups[index],
		\addAction, \addToHead,
		\index, index,
		\callback, ~updateView
	).play;
}
)