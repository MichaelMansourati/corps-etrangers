//startup
(thisProcess.nowExecutingPath.dirname+/+"controlCentre.scd").load;


//run this block to create the simple loop function
(
//how long a melody exists before it is replaced
~melodyLifetime = 30;
~melodyCreator = {
	var getMelodyLength = { rrand(3, 6) };
	var getMelodyDurs = { |length| Array.fill(length, { rrand(3, 10) }) };
	var getMelodyFreqs = { |length| Array.fill(length, { rrand(40, 160) })};
	var len = getMelodyLength.value;

	(
		freqs: [ getMelodyFreqs.value(len), getMelodyFreqs.value(len), getMelodyFreqs.value(len)],
		durs: getMelodyDurs.value(len)
	)
};

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

~setup.value();

//run melody cycler and loop
(
x = {
	//every twenty seconds, set ~subject to a new random melody
	TempoClock.sched(0, {
		~melody = ~melodyCreator.value.postln;
		~melodyLifetime;
	});

	~simpleLoop.value;
}.value;
)