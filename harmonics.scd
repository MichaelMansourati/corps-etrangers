Server.killAll;

// MIDI Control
MIDIClient.init;
MIDIIn.connectAll;

MIDIdef(\uControl).free;
~controlvals = Array.newClear(17);
~harmonics = Array.newClear(17);
(
MIDIdef.cc (\uControl,  {
	//"rcvd".postln;
	arg val, num, chan, src;
	var sigout;
//	[val, num].postln;
	~controlvals[num] = val/127; // map a linear range 0-127 to an exponential range as specified
	[num,val].postln;
	~harmonics[num].set(\amp, ~controlvals[num]);
});




SynthDef(\harmonicControl, {
	arg index = 1, baseFreq = 75, amp = 0;
	var env = EnvGen.ar(Env([0, 1], [1]));
	Out.ar(
		0,
		LFTri.ar(baseFreq * (index), 0, amp/index) * env
	);
}).add;

a = {
	16.do({ |i| ~harmonics[i + 1] = Synth(\harmonicControl, [\index, i+1, \baseFreq, 60, \amp, ~controlvals[i+1]])})
}.play;

)

~controlvals.postln;