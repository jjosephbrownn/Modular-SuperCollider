s.options.device_("ASIO : ASIO4ALL v2");//miss this out if you're ok with the standard sound driver
s.boot;
p=ProxySpace.push(s)
//run this to smooth out transitions
p.fadeTime=5

//triggers for two sound files
//Dust plays random impulses from 0 - 1, good for stochastic jerky triggers
(
~drumTrig = {Dust.kr(2)};
~snareTrig = {Dust.kr(1)};
)

//load up some samples into variables
//you can drag and drop a file into read's second argument
b = Buffer.read(s, "C:/Users/jwh93/Documents/collisions/samples/drums/kick1.wav");
c = Buffer.read(s, "C:/Users/jwh93/Documents/collisions/samples/drums/snare1.wav");
d = Buffer.read(s, "C:/Users/jwh93/Documents/collisions/samples/drums/hat1.wav");

//a buffer player that plays a soundfile when triggered
//PlayBuf's fourth argument is a trigger which plays the file, which would normally be a 1.  In this case we have connected the output from "drumTrig" to this instance of PlayBuf.
(
~drum = { arg rate = 1;
	PlayBuf.ar(1, b, BufRateScale.kr(b)*rate, ~drumTrig,0,0)};
)

~drum.play(0,2)//plays the sound in stereo
~drum.stop;

//another sampler with a variable to control the rate
(
~snare = { var rate = LFNoise0.kr(5).range(0.5,1.5);
	PlayBuf.ar(1, c, BufRateScale.kr(c)*rate, ~snareTrig,0,0)};
)

//instant Aphex Twin
(
~drum.play(0,2);
~snare.play(0,2);
)

(
~drum.stop;
~snare.stop;
)

//still pretty static though.  We could makt this an actual gate signal by using ideas from the previous example

(
~gate = {
	arg freq = 0.5, width = 0.75;
	Pulse.kr(freq,width)};
)

//this time, the snare is triggered by "gate" and an envelope is triggered simultaneously which allows us to control how much of the sample is played.  This works better with longer samples like reverby snares.
(
~snare = { var rate = 1;
	PlayBuf.ar(1, c, BufRateScale.kr(c)*rate, ~gate,0,0) * EnvGen.kr(Env.asr(0.01,0.9,0.01),~gate)};
)

~gate.set(\width,0.25);//play with this "gate" argument to determine the length of the sample
~snare.play(0,2);
~snare.stop;

//as an added bonus, i'll add a sample and hold to the snare playback rate - a new rate is chosen everytime the snare is triggred
(
~snare = {var rate = Latch.ar(LFNoise0.ar(2),~gate).range(0.5,1.5);
	PlayBuf.ar(1, c, BufRateScale.kr(c) * rate, ~gate,0,0) * EnvGen.kr(Env.asr(0.01,0.9,0.01),~gate)};
)

~snare.play(0,2);
~snare.stop;

//the trigger signal could be anything, as longs as there is a negative to positive transition somewhere.  A common gate/trigger is a low frequency square wave as this makes a regular "clock" pulse and the pulse-width forms a natural on/off signal.  Lets try something a bit weirder then.

(
~trig = {arg freq = 0.5;
	SinOsc.kr(freq)};
)

(
~trigger = {
	var freq = ~trig.kr;
	var signal;

	signal = SinOsc.ar([freq.range(50,100),freq.range(75,150)])};
)


~trigger.stop;

(
~drum = {var rate = ~trig.kr;
	PlayBuf.ar(1, b, BufRateScale.kr(b) * rate.range(0.5,1.5), ~trig,0,0)};
)

(
~trigger.play(0,2);
~drum.play(0,2);
)

~trig.set(\freq,2);

//pretty cheesy ;)
//how about...

(
~trig = {arg freq = 2;
	var sig;
	sig = SinOsc.kr(freq) * Pulse.kr(freq)};

~hatTrig = {arg freq = 4;
	var sig;
	sig = SinOsc.kr(freq) * Pulse.kr(freq)};
)

(
~hat = {var rate = 1;
	PlayBuf.ar(1, d, BufRateScale.kr(d) * rate, ~hatTrig,0,0)};
)

(
~trigger.play(0,2);
~drum.play(0,2);
~hat.play;//hihat in left channel
)

(
~trigger.stop;
~drum.stop;
~hat.stop;
)


















