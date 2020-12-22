(
SynthDef(\randomDrum, {
	arg freq = 100, target = 1, out = 0;
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
		sig * EnvGen.kr(Env.adsr(0, 0, 1, 0.2), doneAction: Done.freeSelf)
	);
}).add;
)