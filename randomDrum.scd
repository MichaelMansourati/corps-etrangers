(
SynthDef(\randomDrum, {
	arg freq = 100, out = 0, gate = 1;
	var envBufNum = Buffer.sendCollection(s, Env.perc(0.001, 0.1).discretize, 1);

	var sig = GrainSin.ar(
		numChannels: 1,
		trigger: Dust.ar(1.5),
		dur: 0.2,
		freq: LFNoise0.kr(10, freq*0.5, freq*1.5),
		envbufnum: envBufNum,
		mul: 0.5
	);

	Out.ar(
		out,
		sig * EnvGen.ar(Env([0, 1, 0], [1, 1], releaseNode: 1), gate: gate, doneAction: Done.freeSelf)
	);
}).add;


~randomDrum = {
	arg freq = 200, out = 0, target = 1;
	Synth(
		\randomDrum,
		[
			\freq, freq,
			\out, out
		],
		target,
		\addToHead

	);
};
)