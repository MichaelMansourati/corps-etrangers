s.boot;
Server.killAll;

// MIDI Control
MIDIClient.init;
MIDIIn.connectAll;

MIDIdef(\uControl).free;
~controlVals = Array.fill(17, { 0; });
(
var baseFreq, partialsCount, startPartial, bias, x1, x2, calcAmp, harmSteer;
~synths = Array.fill(1, 0);
partialsCount = 6;


SynthDef(\harmonic, {
	arg baseFreq = 20, harmonic = 1, amp = 0.5;
	var env = EnvGen.ar(Env([0, 1], [1]));
	Out.ar(
		0,
		SinOsc.ar(baseFreq * harmonic, 0, amp/partialsCount) * env
	);
}).add;

baseFreq = 40;
startPartial = 3;
bias = ~controlVals[1];
calcAmp = { |i|
	(1 - bias) + ((i/(partialsCount - 1) * ((2 * bias) - 1)))
};

harmSteer = {
	partialsCount.do({ |i|
		~synths = ~synths.add(Synth.new(\harmonic, [
			\baseFreq, baseFreq,
			\harmonic, startPartial + i,
			\amp, calcAmp.value(i).postln;
		]));
	});
};

MIDIdef.cc (\uControl,  {
	arg val, num, chan, src;

	~controlVals[num] = val/127;
	bias = ~controlVals[1];
	bias.postln;
	partialsCount.do { |i|
		~synths[i + 1].set(\amp, calcAmp.value(i));
	}
});

a = harmSteer.value();
)

~synths.postln;