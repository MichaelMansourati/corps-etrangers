//open and run pitchModulation.scd first!

//run this block to create the simple loop function
(
~simpleLoop = {
	arg instArray = [1, 4];
	var getRandomSound = { [~randomDrum, ~worms].choose.postln; };
	var getPlayTime = { rrand(10, 20) };
	var getWaitTime = { rrand(5, 15) };

	instArray.do({ |i|
		Task({
			{
				~instPatterns[i] = getRandomSound.value.value(
					100, //for the worm function, this argument doesn't do anything yet
					~instBusses[i],
					~instGroups[i]
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

//run function
x = ~simpleLoop.value;

//run these lines to force stop
//this is currently broken
x.stop;
~instPatterns[1].stop;
~instPatterns[4].stop;
~instGroups[1].set(\gate, 0);
~instGroups[4].set(\gate, 0);


//at the top level, a function is decided for each instrument