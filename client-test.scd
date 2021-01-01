// eventually will be array of multiple servers, each corresponding to an instrument
~serverArray = Array.new(1);


// create reference to a remote server
(
var rasPiIp, rasPiNetAddr, serverOptions, rasPiServer;

rasPiIp = "192.168.2.116";
rasPiNetAddr = NetAddr(rasPiIp, 57110);

serverOptions = ServerOptions.new;
serverOptions.protocol = \tcp;
serverOptions.maxLogins = 2;

rasPiServer = Server.remote(\raspberryPi, rasPiNetAddr, serverOptions);
~serverArray.add(rasPiServer);
)


//connect to remote server
//only required if first time connecting to that server instance
(
~serverArray[0].addr.connect;
~serverArray[0].startAliveThread( 0 );

~serverArray[0].doWhenBooted({
	"tcp client connected".postln;
	~serverArray[0].notify;
	~serverArray[0].initTree
});
)


//sample synth
SynthDef.new(\source, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		doneAction: Done.freeSelf
	);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;


//shorthand
~serverArray[0];


//msg send test
~serverArray[0].sendMsg("/s_new", \source, 5, 0, 1);