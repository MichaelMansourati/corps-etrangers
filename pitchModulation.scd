(
// define simple sinOsc synth
SynthDef.new(\longTone, {
	arg freq = 100, lag = 2;

	var freqOut = Lag.kr((freq!2), lag);
	var env = EnvGen.ar(Env([0, 0.2], [1]));
	Out.ar(
		0,
		SinOsc.ar(freqOut) * env;
	);
}).add;
)

(
// define reused functions at the top
var makeWorm, threeWorms;
var getWait = { rrand(5, 30) };

// routine to create a synth and a loop that continuously changes its freq and lag
makeWorm = Routine({
	var getFreq = { rrand(30, 175) };
	var getLag = { rrand(1, 4) };

	var worm = Synth(\longTone, [\freq, getFreq.value()]);
	{
		getWait.value().yield;
		worm.set(\lag, getLag.value());
		worm.set(\freq, getFreq.value());
	}.loop;
});

// routine to create three instances of the synth "worm" and play them with staggered entrances
threeWorms = Routine({
	var worm1 = makeWorm.p;
	var worm2 = makeWorm.p;
	var worm3 = makeWorm.p;
	worm1.play;
	getWait.value().wait;
	worm2.play;
	getWait.value().wait;
	worm3.play;
});

// play the worms
threeWorms.play;
)