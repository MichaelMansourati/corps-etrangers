//run this block to configure and boot the server, create the busCondenser SynthDef,
//as well as create the setup function
(
(thisProcess.nowExecutingPath.dirname+/+"threeTonesCoreFunc.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"sustains.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"randomDrum.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"pitchModulation.scd").load;
(thisProcess.nowExecutingPath.dirname+/+"melodiesFactory.scd").load;

s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 1;
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
	var createViews = {
		arg instCount = 6, parent = nil;
		Array.fill(instCount, { |i| StaticText.new(parent, Rect(5, (5 + (i * 25)), 300, 15)); });
	};

	//free groups and busses before recreating (patterns can just be overWritten)
	~instGroups.do({|group| group.free; });
	~instBusses.do({|bus| bus.free; });

	//create groups, busses, patternPlaceholders, and views
	~instGroups = createGroups.value(instCount);
	~instBusses = createBusses.value(instCount);
	~instPatterns = createPatternPlaceholders.value(instCount);

	//free the condenser before recreating
	~condenser.free;

	//instantiate busCondenser for all six busses
	~condenser = Synth(\busCondenser, target: 1, addAction: \addToTail);

	// create dashboard window
	~dashboard.notNil.postln;
	if(~dashboard.notNil, { ~dashboard.close; }, {});
	~dashboard = Window("Dashboard", Rect(10, 10, 800, 500)).front;
	~melodiesTable = View(~dashboard);
	~instViews = createViews.value(instCount, ~dashboard);
};

~updateView = {
	arg event;
	var index = event.asStream[\index];
	{
		topEnvironment[\instViews][event.asStream[\index]].string = "bus "+ event.asStream[\index]+" freqs: "+ event.asStream[\freq];
	}.defer;
};

~showLevelsAndTree = {
	s.meter;
	s.plotTree;
};
)
