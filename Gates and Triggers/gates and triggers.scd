//this file looks at using various signals to trigger and gate sound sources and envelopes

s.options.device_("ASIO : ASIO4ALL v2");//miss this out if you're ok with the standard sound driver
s.boot;

p=ProxySpace.push(s);//gotta be using the ol' ProxySpace
// a simple square wave with a frequency of 1 and pulse width of 0.5
~gate = {Pulse.kr(1,0.5)};

// a nice sound - but it just goes on forever
~saw = {Saw.ar([220,222])};
~saw.play;

//we can use gate to trigger an envelope's attack and release phase

~saw = {Saw.ar([220,222]) * EnvGen.ar(Env.asr(0.1,0.5,0.1),~gate)};

~saw.play
//oh yeah, thats the iritatiing sound we were after
//("gate" doesn't need a play method as all proxies are started when they are initialised - play assigns them an output bus but in the case of "gate" we would be monitoring a control rate proxy (.kr) which is not allowed
~saw.stop;

//lets make it a bit more flexible by rewriting the "saw" sound

(
~saw = {
	arg atk = 0.1, dec = 0.1;
	Saw.ar([220,222]) * EnvGen.ar(Env.asr(atk,0.5,dec),~gate)};
)
~saw.play;

//we can change some of the envelope values by accessing the arguments:
~saw.set(\atk, 0.5);
~saw.set(\dec,0.5);
~saw.stop;

//we could do the same thing with "gate"
(
~gate = {
	arg freq = 2, width = 0.75;
	Pulse.kr(freq,width)};
)
~saw.play;
~gate.set(\freq,5);
~gate.set(\width,0.9);

//setting some of these values will sort of "override" the envelope attack and decay settings as the time from trigger to release may be longer than the total attak and decay times
~saw.stop;

//we'll write something that will do some of this sequencing for us

(
~gate = {arg modFreq = 0.5;
	var pulse = LFNoise0.ar(1).range(0.25,0.9);
	var freq = SinOsc.ar(modFreq).range(0.5,2);
	Pulse.kr(freq,pulse)};
)
~saw.set(\atk,0.1);
~saw.set(\dec,0.1);
~saw.play;
//noice
~gate.set(\modFreq,1);
~saw.stop;

//you could save any of the numbers above into an argument and then access them in this way

//here's something i made earlier
//*produces code as if it took no time at all

(
~osc1 = { arg atk = 0.1,dec = 0.1;
	var ringFreq = LFNoise0.kr([5,6]).range(200,1000);//the [] here is called "multichannel expansion" - it basically turns the LFNoise into two sound sources which makes the whole thing STEREO.
	var source1;

	source1 = RLPF.ar(SinOsc.ar(LFNoise0.kr(1).range(50,500)),ringFreq) * EnvGen.kr(Env.asr(atk, 0.5,dec),~gate)};
)

(
~osc2 = { arg atk = 0.1,dec = 0.2;
	var ringFreq = LFNoise0.kr([5,6]).range(200,1000);
	var source1;

	source1 = RLPF.ar(SinOsc.ar(LFNoise0.kr(1).range(50,500)),ringFreq) * EnvGen.kr(Env.asr(atk, 0.5,dec),~gate)};
)

~osc = {~osc1.ar * ~osc2.ar}; //multiple them to make it sound extra good
~osc.play;
~gate.set(\modFreq,0.1);

//change back to an earlier form of "gate" for something punchier
(
~gate = {
	arg freq = 4, width = 0.5;
	Pulse.kr(freq,width)};
)
~gate.set(\freq,4);
~osc.stop;
//ta da - modular synth




~sound = {SinOsc.ar(LFNoise0.kr(1).range(100,200))};
~sound.play(0,2)

~trig = {Trig.ar(~sound,0.1) * FSinOsc.ar(800,0.5)};
~trig.play(0,2);
~sound.stop;
~trig.stop;
