Server.killAll;
ServerOptions.devices;


(
SynthDef.new(\longTone, {arg freq = 100;
	Out.ar(
		0,
		SinOsc.ar((freq!2).lag(3),  0, 1) * 0.2;
	);
}).add;
)
(
var getFreq = { rrand(30, 175).postln; };
var getWait = { rrand(5, 20) };

u = Routine({
	v = Synth(\longTone, [\freq, getFreq.value()]);
	{
		getWait.value().yield;
		v.set(\freq, getFreq.value());
	}.loop;
});
w = Routine({
	x = Synth(\longTone, [\freq, getFreq.value()]);
	{
		getWait.value().yield;
		x.set(\freq, getFreq.value());
	}.loop;
});
y = Routine({
	z = Synth(\longTone, [\freq, getFreq.value()]);
	{
		getWait.value().yield;
		z.set(\freq, getFreq.value());
	}.loop;
});
u.play;
w.play;
y.play;
)