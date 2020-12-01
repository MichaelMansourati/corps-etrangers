(
s.options.protocol = \tcp; // set to use tcp
s.options.bindAddress = "0.0.0.0"; // allow connections from any address
s.options.maxLogins = 2; // set to correct number of clients
s.boot;
)

(
SynthDef(\ping, { |out|
    Out.ar(out,
        SinOsc.ar(rrand(400, 800), 0, 0.2) * Line.kr(1, 0, 1, doneAction: Done.freeSelf)
    )
}).add;
x = Synth(\ping, 0);
)

Server.killAll;


{ SinOsc.ar(100, 0, 0.2) }.play;

s.notify("ping");

~rpi = NetAddr.new("192.168.2.116", 57120);

~rpi.sendMsg('/s_new', \ping, 1234, 0, 1);

(dur: inf, degree: 2, group: 67108865).play;

s.defaultGroups;