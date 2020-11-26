s.boot;
Server.killAll;

// MIDI Control
MIDIClient.init;
MIDIIn.connectAll;

MIDIdef(\uControl).free;
~controlvals = Array.newClear(17); //an array of 16 values (0th value unused)
~harmonics = Array.newClear(17);
(
MIDIdef.cc (\uControl,  {
	//"rcvd".postln;
	arg val, num, chan, src;
	~controlvals[num] = val/127;
	[num,val].postln;
	~harmonics[num].set(\amp, ~controlvals[num]);
});

SynthDef(\harmonicControl, {
	arg index = 1, baseFreq = 10, amp = 0;
	var env = EnvGen.ar(Env([0, 1], [1]));
	Out.ar(
		0,
		SinOsc.ar(baseFreq * (index)/* + LFNoise1.ar(2, 3)*/, 0, amp/index) * env
	);
}).add;

/*SynthDef(\harmonicControl).free;*/

a = {
	16.do({ |i| ~harmonics[i + 1] = Synth(\harmonicControl, [\index, i+1, \baseFreq, 60, \amp, ~controlvals[i+1]])})
}.play;



)
~harmonics.postln;
~controlvals.postln;

