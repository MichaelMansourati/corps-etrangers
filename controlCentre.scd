s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 1;
s.meter;

//repeating ping - sample synth
(
SynthDef.new(\pingTest, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(out, sig); //out to an arbitrary destination
}).add;
)


(
var createBusses = { arg instCount = 6;
	Array.fill(instCount, { Bus.audio(s, 1) });
};
//a bus for each hypothetical instrument (can be later routed to other
~instBusses = createBusses.value(6);

//route designated bus to channel 0 (which will eventually be channel 0 of the remote instrument server
SynthDef(\busToServer, {
	arg bus = 3, out = 0;
	Out.ar(bus, out);
}

//for test purposes, condense all remaining busses and splay them across stereo field
SynthDef(\busCondenser, {
	arg bus = 4, numChannels = 5;
	var inChannels = In.ar(bus, numChannels);
	var splayedChannels = Splay.ar(inChannels);
	Out.ar(0, splayedChannels);
}).add;
)

(
Synth(\busToServer, [\bus, ~instBusses[0], \out, 0]);
Synth(\busCondenser);
)

//run each line here individually

//untested line (stuff for remote server
~rpis.sendMsg(\s_new, \busToServer, ~rpi.nextNodeID, 0, 1);



a = Synth(\pingTest, [\freq, 100, \out, ~instBusses[1]]);
b = Synth(\pingTest, [\freq, 200, \out, ~instBusses[2]]);
c = Synth(\pingTest, [\freq, 150, \out, ~instBusses[3]]);
d = Synth(\pingTest, [\freq, 250, \out, ~instBusses[4]]);
e = Synth(\pingTest, [\freq, 300, \out, ~instBusses[5]]);

// modify synths in real time
a.set(\freq, 92);