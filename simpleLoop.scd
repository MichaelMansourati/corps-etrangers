//open and run pitchModulation.scd first!

//run this block to create the simple loop function
(
~simpleLoop = {
	arg instIndex = 2;
	Task({
		{
			~instPatterns[instIndex] = ~worms.value(
				~instBusses[instIndex],
				~instGroups[instIndex]
			);
			10.yield.postln;
			~instPatterns[instIndex].stop;
			~instGroups[instIndex].set(\gate, 0);
			10.yield;
		}.loop;
	}).start;
};
)

//run function
x = ~simpleLoop.value;


//run these lines to force stop
x.stop;
~instPatterns[2].stop;
~instGroups[2].set(\gate, 0);

