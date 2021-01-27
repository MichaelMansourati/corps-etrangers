
(
(thisProcess.nowExecutingPath.dirname+/+"threeTonesCoreFunc.scd").load;


SynthDef(\threeTonesSustainsWrapper, {
	var env = Env(
		levels: [0, 0.3, 0.1, 0],
		times: [0.01, 0.75, 1],
		curve:[0, -4, 0],
		releaseNode: 2
	);
	SynthDef.wrap(~threeTonesCoreFunc, nil, [env]);
}).add;

~sustains = { arg out = 0, target = 1, melody =
	(
		freqs: [
			[100, 110, 120],
			[160, 170, 180],
			[130, 140, 150]
		],
		durs: [5, 5, 5]
	);

	p = Pbind(
		\instrument, \threeTonesSustainsWrapper,
		\dur, Pseq(melody[\durs], 1),
		\freq1, Pseq(melody[\freqs][0], 1),
		\freq2, Pseq(melody[\freqs][1], 1),
		\freq3, Pseq(melody[\freqs][2], 1),
		\sustain, Pkey(\dur) * Pwhite(0.0, 0.9, inf),
		\gate, 1,
		\out, out,
		\group, target,
		\addAction, \addToHead
	).play;
}
)