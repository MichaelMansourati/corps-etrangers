//run this block to configure and boot the server, create the busCondenser SynthDef,
//as well as create the setup function
(
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 1;
s.meter;
s.outputBus;

s.boot;

//for test purposes, condense all busses and splay them across stereo field
//number of channels for In.ar() MUST be static/ maybe we can use prependArgs to get around this(?)
SynthDef(\busCondenser, {
	arg bus = ~instBusses[1].index.postln;
	var inChannels = In.ar(3, 6).postln;
	var splayedChannels = Splay.ar(inChannels);
	Out.ar(0, splayedChannels);
}).add;


~setup = {
	//number of instruments being used
	arg instCount = 6;

	var createBusses = { arg instCount = 6;
		Array.fill(instCount, { Bus.audio(s, 1).postln; });
	};
	var createGroups = { arg instCount = 6;
		Array.fill(instCount, { Group.new().postln; });
	};

	//free groups and busses before recreating
	~instGroups.do({|group| group.free; });
	~instBusses.do({|bus| bus.free; });

	//create groups and busses
	~instGroups = createGroups.value(instCount);
	~instBusses = createBusses.value(instCount);
	~instBusses[1].postln;

	//free the condenser before recreating
	~condenser.free;

	//instantiate busCondenser for all six busses
	~condenser = Synth(\busCondenser, target: 1, addAction: \addToTail);
}
)

//call the setup function to actually create the environment.
//You can pass a number as an argument in value() to choose the number of instruments
~setup.value();

//these are the environment variables we created with the ~setup function.
//they can be called from any file once the ~setup function has been called.
//you can also call ~setup from any file as well
//you can run each of these lines individually to see what they represent in the post window
~instGroups;
~instBusses;
~condenser;

//take a look at the node tree as well:
s.plotTree;


///////////////////////////////////
// TESTING MATERIAL ///////////////
///////////////////////////////////

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

