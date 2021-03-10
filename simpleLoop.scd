//startup
(thisProcess.nowExecutingPath.dirname+/+"controlCentre.scd").load;


//run this block to create the simple loop function
(
~simpleLoop = {
	arg instArray = [2, 3, 4];
	var getRandomSound = { [~randomDrum, ~sustains, ~worms].choose; };
	var getWaitTime = { rrand(4, 5) };


	instArray.do({ arg instNum, index;
		Task({
			{

				(getWaitTime.value * index).yield;
				~instPatterns[instNum] = getRandomSound.value.value(
					instNum,
					~melody
				);

				~melody[\durs].sum({|i| i }).yield;

				~instPatterns[instNum].stop;
				~instGroups[instNum].set(\gate, 0);
				{ ~instViews[instNum].string = "bus "+instNum+" freqs: []"; }.defer;
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