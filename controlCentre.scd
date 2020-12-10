s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 1;
s.meter;

s.outputBus

(
var createBusses = { arg instCount = 6;
	Array.fill(instCount, { Bus.audio(s, 1).postln; });
};
//a bus for each hypothetical instrument (can be later routed to other
~instBusses = createBusses.value(6);

//route designated bus to channel 0 (which will eventually be channel 0 of the remote instrument server)
SynthDef(\busToServer, {
	var bus = 3, out = 0;
	Out.ar(bus, out);
}).add;

//for test purposes, condense all busses and splay them across stereo field
//number of channels for In.ar() MUST be static.
SynthDef(\busCondenser, {
	arg bus = ~instBusses[1].index.postln;
	var inChannels = In.ar(3, 6).postln;
	var splayedChannels = Splay.ar(inChannels);
	Out.ar(0, splayedChannels);
}).add;
)
//instantiate busToServer (not needed right now)
// var toServer = Synth(\busToServer, [\bus, ~instBusses[0], \out, 0]);

//instantiate busCondenser for last five busses
~condenser = Synth(\busCondenser, target: 1, addAction: \addToTail);
~condenser.free;

//untested line (stuff for remote server
// ~rpis.sendMsg(\s_new, \busToServer, ~rpi.nextNodeID, 0, 1);


// USEFUL PARTS OF THIS FILE
// the salient things we need here are the ~condenser and the ~instBusses
// the ~instbusses we can use as stand-ins for instruments while iterating and testing locally
// the ~condenser is what crams them into the stereo field we can hear through headphones

















////////////////////////////////////////////////////////////////////////////////////////
// TESTING MATERIAL ///////////////

//repeating ping - sample synth
(
SynthDef(\pingTest, {
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
//run each line here individually
//if you stagger the entry of each synth instance here,
//you can hear how each bus pans each synth slightly differently,
//so that you can hear them as separate entities
a = Synth(\pingTest, [\freq, 100, \out, ~instBusses[0]]);
b = Synth(\pingTest, [\freq, 200, \out, ~instBusses[1]]);
c = Synth(\pingTest, [\freq, 150, \out, ~instBusses[2]]);
d = Synth(\pingTest, [\freq, 250, \out, ~instBusses[3]]);
e = Synth(\pingTest, [\freq, 300, \out, ~instBusses[4]]);
f = Synth(\pingTest, [\freq, 350, \out, ~instBusses[5]]);

