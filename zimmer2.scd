s.boot;
s.quit;
s.killall;

//measuring tools
(s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)

//load buffer(s)
c = Buffer.readChannel(s, "/Users/em/Google Drive/Cor(p)s étrangers/Source audio/pedal C.wav", channels:[0]);
f= Buffer.readChannel(s, "/Users/em/Google Drive/Cor(p)s étrangers/Source audio/PedalF.aif", channels:[0]);

// buffer diagnostics
c.play;
f.play;
c.query;
c.numFrames/c.sampleRate; // return buffer length in seconds
f.query;
f.numFrames/f.sampleRate; // return buffer length in seconds


// second version - a bit cleaner and more logical.
(
{
	var numChannels, density, trig, dur, transpose, pos, interp, pan, envbuf, maxGrains, sigout, sigout1, sigout2;
	numChannels = 2;
	maxGrains = 512;
	density = 40; // number of new grains created per second. 40 is a great value for this
	trig = Impulse.ar(density); // trig is what cues GrainBuf to evaluate all the other variables & make a new grain
	dur = density/12; // this is in seconds, so quite long! was previously set to density/4 i.e. 10 seconds
	// once everything's rolling, number of grains ~= density * dur
	//dur = (maxGrains)/density-1; // might be another way of maximizing overall number of grains!
	transpose = MouseY.kr(0.5,2,1);
	interp = 2; //2= apply linear interpolation when transpose value changes. other values are 4 (cubic interp) or 1 (no interp)
	pos = MouseX.kr(0,1); //plus a small TRand value added below
	(pos*c.numFrames/c.sampleRate).poll(density); // post the position of the most recently created grain (in seconds)
	pan = WhiteNoise.kr(0.6); // -1 hard left, +1 hard right
	envbuf = -1; // -1 denotes built-in Hanning envelope
	sigout1 = GrainBuf.ar(numChannels, trig, dur, c, transpose, pos+ TRand.kr(0,0.001,trig), interp, pan, envbuf, maxGrains);
	sigout2 = GrainBuf.ar(numChannels, trig, dur, c, transpose*2, pos+ TRand.kr(0,0.001,trig), interp, pan, envbuf, maxGrains);
	sigout = (sigout1 + sigout2)/density*4;
	Out.ar(0,sigout)
}.play;
)

// first version - really nice, but the way it calculates dur is kind of illegal
(
{
var numChannels, density, trig, dur, transpose, pos, interp, pan, envbuf, maxGrains, sig;
	numChannels = 2;
	trig = Impulse.ar(40);
	density = 10;
	//dur = density/trig; //that should not be trig
	dur = density;
	transpose = MouseY.kr(0.5,2,1);
	pos = MouseX.kr(0,1)+ TRand.kr(0,0.01,trig);
	interp = 2;
	pan = WhiteNoise.kr(0.6);
	envbuf = -1;
	maxGrains = 512;
	sig = GrainBuf.ar(numChannels, trig, dur, c, transpose, pos, interp, pan, envbuf, maxGrains);
	sig = sig/density;
	Out.ar(0,sig)}.play;
)


