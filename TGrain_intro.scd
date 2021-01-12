s.boot;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b.play;

(
{
    var trate, dur, trig, transpose, pos, pan, amp;
	    trate = MouseY.kr(8,120,1); //MouseY's args are minval, maxval, warp (0-1 lin-exp)
    dur = 12 / trate; // duration of grain in seconds. based on min&max above this yields 1.5-0.1 sec
	trig = Impulse.kr(trate); // At each trigger, sample TGrain's other arguments to create a new grain
    transpose = 1; //1 = normal, 2=octave up, 0.5=octave down, -1=backwards, etc
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, trig); // centerpoint of grain wrt source file start, in seconds. the TRand helps avert robotic sounding result
    pan = WhiteNoise.kr(0.6);
	amp = 0.3;
    TGrains.ar(2, trig, b, transpose, pos, dur, pan, amp);
}.scope(zoom: 4);
)


(
{
    var trate, dur, rate;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
	    rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf); //Dseq is a "Demand rate" sequence generator
    TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4);
)


(
{
    var trate, dur, trig, pos, pan;
    trate = 12;
    dur = MouseY.kr(0.2,24,1) / trate; //in this one the grain duration is set by mouse vertical position
    trig = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b));// + TRand.kr(0, 0.01, trig);
    //pan = WhiteNoise.kr(0.6);
	pan = 0.5;
    TGrains.ar(2, trig, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)
