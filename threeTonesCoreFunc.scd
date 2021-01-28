(
~threeTonesCoreFunc = {
	arg env, freq1 = 100, freq2 = 200, freq3 = 300, out = 0, gate = 1;

	var envLocal = EnvGen.ar(
		env,
		gate: gate,
		doneAction: Done.freeSelf
	);

	Out.ar(
		out,
		Mix([
			SinOsc.ar(freq1),
			SinOsc.ar(freq2),
			SinOsc.ar(freq3)
		]) * envLocal
	);
};
)