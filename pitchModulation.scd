
(
var getFreq = Pwhite(50, 175, inf);
var getLag = Pwhite(2, 2, inf);
var getWait = Pwhite(3, 5, inf);
var threeTonesInstance;

SynthDef.new(\threeTones, {
	arg freq1 = 100, freq2 = 200, freq3 = 300, lag = 2, out = 0, gate = 1;

	var getFreqOut = {|freq| Lag.kr(freq, lag)};
	var freqOut1 = getFreqOut.value(freq1);
	var freqOut2 = getFreqOut.value(freq2);
	var freqOut3 = getFreqOut.value(freq3);
	var env = EnvGen.ar(Env([0, 0.2, 0], [1, 1], releaseNode: 1), gate: gate, doneAction: Done.freeSelf);
	Out.ar(
		out,
		Mix([SinOsc.ar(freqOut1), SinOsc.ar(freqOut2), SinOsc.ar(freqOut3)]) * env
	);
}).add;

//freq arg doesn't do anything yet
~worms = { arg freq, out, target;
	threeTonesInstance = Synth(
		\threeTones,
		[
			\freq1, getFreq.asStream.next,
			\freq2, getFreq.asStream.next,
			\freq3, getFreq.asStream.next,
			\out, out
		],
		target,
		\addToHead
	);

	p = Pbind(
		\id, threeTonesInstance,
		\type, \set,
		\args, Prand(#[[\freq1], [\freq2], [\freq3]], inf),
		\dur, getWait.trace,
		\freq1, getFreq.trace,
		\freq2, getFreq.trace,
		\freq3, getFreq.trace,
		\lag, getLag.trace,
		\gate, 1,
	).play;
}
)