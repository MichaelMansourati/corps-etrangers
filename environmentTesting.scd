//these are the environment variables we created with the ~setup function.
//they can be called from any file once the ~setup function has been called.
//you can also call ~setup from any file as well
//you can run each of these lines individually to see what they represent in the post window
//there should be a 6-item array for each of the ~inst____s
~instGroups;
~instBusses;
~instPatterns;
~condenser;

//take a look at the node tree as well:
s.plotTree;


///////////////////////////////////
// TESTING MATERIAL ///////////////
///////////////////////////////////

//repeating ping - sample synth
(
SynthDef(\pingTest, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(out, sig); //out to an arbitrary destination
}).add;
)
//run each line here individually
//if you stagger the entry of each synth instance here,
//you can hear how each bus pans each synth slightly differently,
//so that you can hear them as separate entities
a = Synth(\pingTest, [\freq, 100, \out, ~instBusses[0]]);
b = Synth(\pingTest, [\freq, 200, \out, ~instBusses[1]]);
c = Synth(\pingTest, [\freq, 150, \out, ~instBusses[2]]);
d = Synth(\pingTest, [\freq, 250, \out, ~instBusses[3]]);
e = Synth(\pingTest, [\freq, 300, \out, ~instBusses[4]]);
f = Synth(\pingTest, [\freq, 350, \out, ~instBusses[5]]);
