(
//load buffer(s)
c = Buffer.readChannel(s, thisProcess.nowExecutingPath.dirname +/+ "/sourceAudio/pedalCShort.wav", channels:[0]);

SynthDef(\zimmer, {
	arg freq = 32.7, gate = 1;

	var pedalCFreq = 32.7;
	var transpose = freq/pedalCFreq;
	var numChannels = 2;
	var maxGrains = 512;
	var density = 20; // number of new grains created per second. 40 is a great value for this
	var trig = Impulse.ar(density);
	var dur = 0.75;
	var interp = 2;
	var pos = 0.5 + LFNoise0.kr(10, 0.4); //fluctuate back and forth across the sample
	var pan = 0; // -1 hard left, +1 hard right
	var envbuf = -1; // -1 denotes built-in Hanning envelope
	var sigout = GrainBuf.ar(numChannels, trig, dur, c, transpose, pos, interp, pan, envbuf, maxGrains);
	var env = EnvGen.ar(Env([0, 0.2, 0], [0, 1], releaseNode: 1), gate: gate, doneAction: Done.freeSelf);

	// (pos*c.numFrames/c.sampleRate).poll(density); //log position of grain in sec

	Out.ar(0,sigout*env)
}).add;

~zimmer = {
	arg out = 0, target = 1, freq = 100, melody = (
		freqs: [100, 110, 120],
		durs: [1, 1, 1]
	);
	Pmono(
		\zimmer,
		\freq, Pseq(melody[\freqs], 1),
		\dur, Pseq(melody[\durs], 1),
		// \sustain, Pseq(melody[\durs], 1),
		\out, out,
		\group, target,
		\addAction, \addToHead
	).play;
}
)

x = ~zimmer.value;