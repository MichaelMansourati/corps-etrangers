Server.freeAll;
Server.killAll;
z = Buffer.sendCollection(s, Env.perc(0.001, 0.1).discretize, 1);

(
var getRand = { rrand(50, 150).postln; };
{
	var sig;
	sig = GrainSin.ar(
		1,
		Dust.ar(1.5),
		0.2,
		LFNoise0.kr(10, 50, 100),
		envbufnum: z,
		mul: 0.5
	)
}.play;
)