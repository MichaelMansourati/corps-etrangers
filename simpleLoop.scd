//startup
(thisProcess.nowExecutingPath.dirname+/+"controlCentre.scd").load;


//run this block to create the simple loop function
(
~simpleLoop = {
	arg instArray = [1, 2];
	var getRandomSound = { [~randomDrum, ~sustains, ~worms].choose; };
	var getWaitTime = { rrand(1, 3) };


	instArray.do({ |i|
		Task({
			{
				~instPatterns[i] = getRandomSound.value.value(
					~instBusses[i],
					~instGroups[i],
					~melody
				);
				~melody[\durs].sum({|i| i }).yield;
				~instPatterns[i].stop;
				~instGroups[i].set(\gate, 0);
				getWaitTime.value.yield;
			}.loop;
		}).start;
	});
};

)

~showLevelsAndTree.value()
~setup.value();

//run melody cycler and loop
(
x = {
	//every twenty seconds, set ~subject to a new random melody
	TempoClock.sched(0, {
		~melody = ~melodyCreator.value;
		{ ~updateDashboard.value }.defer;
		~melodyLifetime;
	});
	~simpleLoop.value;
}.value;

)