s.options.device_("ASIO : ASIO4ALL v2");
s.boot;
p=ProxySpace.push(s);//gotta be using the ol' ProxySpace


//simple clock with modulated pulsewidth
(
~clock = {
	var freq = SinOsc.kr(1).range(1,4);
	var width = Pulse.kr(2).range(0.5,0.9);
	Pulse.kr(freq,width)};
)

//basic step sequencer using Hz values
//clock increments the sequencer
//and wraps back round to 0 when it hits count max in the curly brackets
(
~step = {
	arg freq = #[100,200,300,50,700,2000];
	Select.kr(Stepper.kr(~clock,0,0,{freq.size-1}),freq)};
)

//simple sound maker
//clock gates and ADSR envelope
//and triggers a filter value
(
~harp = {
	var osc1,osc2,env,sig,filt;

	env = EnvGen.kr(Env.adsr(0.005,0.25,0.25,0.1),~clock);

	osc1 = Resonz.ar(Pulse.ar(~step.kr, 0.5) * env,Latch.kr(LFNoise0.kr(1).range(100,1000),~clock),0.5);
};
)

~harp.play(0,2);
~harp.stop();

//all well and good,but what about a randomised sequencer?
//something that could pick a value out of series of possible values

(
~step = {
	arg notes,freq;
	notes = Drand([100,200,300,400,500,600],inf);
	freq = Demand.kr(~clock,0,notes)};
)

(
~harp = {

	var osc1,osc2,env;
	env = EnvGen.kr(Env.adsr(0.005,0.25,0.25,0.1),~clock);

	osc1 = Resonz.ar(Saw.ar(~step.kr, 0.75) * env,Latch.kr(LFNoise0.kr(10).range(100,1000),~clock),0.75)};
)

~harp.play(0,2);
~harp.stop;

//we could even simplify the values within Drand then transform them against a changeable variable
(
~step = {
	arg notes,freq,offset;
	offset = 40;
	notes = Drand([0,2,3,5,7,9,11,12],inf);//a dorian mode
	freq = Demand.kr(~clock,0,notes+offset).midicps};//scaled up to the 40 midirange then translated to frequency values
)

//the same but with weighted randomness to give the melody more structure

(
~step = {
	arg notes,freq,offset;
	offset = 30;
	notes = Dwrand([0,2,4,5,9,11],[0.3,0.2,0.1,0.1,0.2,0.2],inf);
	freq = Demand.kr(~clock,0,notes+offset).midicps};//scaled up to the 40 midirange then translated to frequency values
)

//new clock because this sort of thing starts to sound inane after a while, and not in a good way
(
~clock = {
	var freq = 8;
	var width = SinOsc.kr(1).range(0.7,0.9);
	Pulse.kr(freq,width)};
)

~harp.play(0,2);
~harp.stop;

//now with some nice sounds.  stop everything and evaluate this.

(
~clock = {
	//var freq = Pulse.kr(1).range(3,6);
	var freq = 6;
	var width = SinOsc.kr(1).range(0.25,0.9);
	Pulse.kr(freq,width)};
)

(//drum machine
a = Buffer.read(s, "C:/Users/jwh93/Documents/collisions/samples/drums/kick1.wav");
b = Buffer.read(s, "C:/Users/jwh93/Documents/collisions/samples/drums/snare1.wav");
c = Buffer.read(s, "C:/Users/jwh93/Documents/collisions/samples/drums/hat1.wav");
~drumClock = {
	var freq = 6;
	Pulse.kr(freq,0.5)};

~kick = { var rate = 1,trig,reset;
	reset = SinOsc.kr(6);
	trig = PulseCount.kr(~drumClock,reset);
	PlayBuf.ar(1, a, BufRateScale.kr(a)*rate,trig,0,0)};

//~snare = { var rate = 1;
//	PlayBuf.ar(1, b, BufRateScale.kr(b)*rate, ~gate,0,0)};

~hat = { var rate = 1;
	PlayBuf.ar(1, c, BufRateScale.kr(c)*rate, ~drumClock,0,0) * 0.5};
)

(
~step = {
	arg notes,freq,offset;
	offset = 40;
	notes = Dwrand([0,2,4,5,9,11],[0.3,0.2,0.1,0.1,0.2,0.2],inf);
	freq = Demand.kr(~clock,0,notes+offset).midicps};//scaled up to the 40 midirange then translated to frequency values
)

(
~osc1 = {
	var sound,filt,env,cutoff;
	cutoff = SinOsc.kr(0.25).range(500,1000);
	env = EnvGen.kr(Env.adsr(0.01,1,0.25,0.1),~clock);
	filt = EnvGen.kr(Env.adsr(0.01,0.5,0.75,0.1).range(0,cutoff),~clock);

	sound = RLPF.ar(Saw.ar(~step.kr, 0.75) * env,filt,0.5)};
)

(
~osc2 = {
	var sound,filt,env,cutoff;
	cutoff = SinOsc.kr(0.25).range(500,1000);
	env = EnvGen.kr(Env.adsr(0.01,1,0.25,0.1),~clock);
	filt = EnvGen.kr(Env.adsr(0.01,0.5,0.5,0.1).range(0,cutoff),~clock);

	sound = RLPF.ar(Saw.ar(~step.kr * 1.5, 0.75) * env,filt,0.55)};
)

~osc1.play(0,2);
~osc2.play(0,2);
~osc2.stop;
~osc1.stop;
~kick.stop;
~hat.stop;
(
~osc1.play(0,2);
~osc2.play(0,2);
~kick.play(0,2);
~hat.play();
)
