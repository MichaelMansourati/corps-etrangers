//open and run pitchModulation.scd first!

//run this block to create the simple loop function
(
//how long a melody exists before it is replaced
~melodyLifetime = 30;
~melodyCreator = {
	var getMelodyLength = { rrand(3, 6) };
	var getMelodyDurs = { |length| Array.fill(length, { rrand(1, 3) }) };
	var getMelodyFreqs = { |length| Array.fill(length, { rrand(40, 160) }) };
	var len = getMelodyLength.value;

	( freqs: getMelodyFreqs.value(len), durs: getMelodyDurs.value(len) );
};

~simpleLoop = {
	arg instArray = [1, 2, 4];
	var getRandomSound = { [~randomDrum, ~worms, ~zimmer].choose.postln; };
	var getPlayTime = { rrand(10, 20) };
	var getWaitTime = { rrand(5, 15) };

	//melody creation (for zimmer synth)


	instArray.do({ |i|
		Task({
			{
				~instPatterns[i] = getRandomSound.value.value(
					~instBusses[i],
					~instGroups[i],
					100,
					~melody //only used by Zimmer synth. other synths not affected
				);
				getPlayTime.value.yield.postln;
				~instPatterns[i].stop;
				~instGroups[i].set(\gate, 0);
				getWaitTime.value.yield;
			}.loop;
		}).start;
	});
};

)


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