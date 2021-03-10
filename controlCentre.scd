//run this block to configure and boot the server, create the busCondenser SynthDef,
//as well as create the setup function
(
(thisProcess.nowExecutingPath.dirname+/+"threeTonesCoreFunc.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"sustains.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"randomDrum.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"pitchModulation.scd").load;

s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 1;
s.meter;
// s.outputBus;

s.boot;

//for test purposes, condense all busses and splay them across stereo field
//number of channels for In.ar() MUST be static/ maybe we can use prependArgs to get around this(?)
SynthDef(\busCondenser, {
	arg bus = ~instBusses[1].index.postln;
	var inChannels = In.ar(3, 6).postln;
	var splayedChannels = Splay.ar(inChannels);
	Out.ar(0, splayedChannels);
}).add;

//setup function to call after server is ready
//You can pass a number as an argument in value() to choose the number of instruments
~setup = {
	//number of instruments being used
	arg instCount = 6;

	var createBusses = {
		arg instCount = 6;
		Array.fill(instCount, { Bus.audio(s, 1).postln; });
	};
	var createGroups = {
		arg instCount = 6;
		Array.fill(instCount, { Group.new().postln; });
	};
	var createPatternPlaceholders = {
		arg instCount = 6;
		Array.newClear(instCount);
	};

	//free groups and busses before recreating (patterns can just be overWritten)
	~instGroups.do({|group| group.free; });
	~instBusses.do({|bus| bus.free; });

	//create groups, busses, and patternPlaceholders
	~instGroups = createGroups.value(instCount);
	~instBusses = createBusses.value(instCount);
	~instPatterns = createPatternPlaceholders.value(instCount);

	//free the condenser before recreating
	~condenser.free;

	//instantiate busCondenser for all six busses
	~condenser = Synth(\busCondenser, target: 1, addAction: \addToTail);
}
~showLevelsAndTree = {
	s.meter;
	s.plotTree;
};
)

