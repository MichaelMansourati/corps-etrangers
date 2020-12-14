(
// define simple sinOsc synth
SynthDef.new(\longTone, {
	arg freq = 100, lag = 2, out = 0, gate = 1;

	var freqOut = Lag.kr((freq.value()!2), lag);
	var env = EnvGen.ar(Env([0, 0.2, 0], [1, 1], releaseNode: 1), gate: gate, doneAction: Done.freeSelf);
	Out.ar(
		out,
		SinOsc.ar(freqOut) * env;
	);
}).add;

s.sync

//randomness generators (do I need to use P*** functions here?)
var getFreq = Pwhite(30, 175, inf);
var getLag = Pwhite(1, 4, inf);
var getWait = Pwhite(5, 15, inf);

//define a Pmono and apply it to synth "x"
~getWormPattern = {
	arg out = 0;

	Pmono(
		\longTone,
		\dur, getWait.trace,
		\freq, getFreq.trace,
		\lag, getLag.trace,
		\gate, 1,
		\out, out
	).play;
};
//copy previous Pbind and apply to synths "y" and "z"
)

a = ~getWormPattern.value(~instBusses[0]);
b = ~getWormPattern.value(~instBusses[2]);
c = ~getWormPattern.value(~instBusses[5]);

[a, b, c].do{|item| item.stop};