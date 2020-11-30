Server.freeAll;
Server.killAll;
z = Buffer.sendCollection(s, Env.perc(0.001, 0.1).discretize, 1);

(
var getRand = { rrand(50, 150).postln; };
{
	var sig;
	sig = GrainSin.ar(
		2,
		Dust.ar(3),
		0.2,
		LFNoise0.kr(10, 50, 100),
		envbufnum: z,
		mul: 1
	)
}.play;
)