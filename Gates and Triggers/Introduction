## All about Gate and Trigger signals

In modular synthesis a trigger signal is a short blip of voltage that acts as an "on" message, like a mouse clicking a button.  This is useful for triggering events that don't need a "stop" - drum samples would come at the top of that list.

Gate signals do have an "off".  This would be like pressing a mouse button to start a sound and releasing it to stop the sound.  Usually the "on" part of the signal is a transition from zero to non-zero and the signal is held on as long as the gate is larger than zero.  The "off" happens when the gate drops back to zero (or below).  Gates are great for playing envelopes as the gate start can be used to trigger the attack and hold the sustain portion until the off part of the gate triggers the release.

Gates can be user controlled (like a midi keyboard key being pressed) or periodic, like a square wave.  These examples will look at the latter.

SC comes with a few inbuilt trigger UGens.
```
Dust.kr(1) //generates randomly timed impulses from 0-1, great for random drum playing
Impulse.kr(1) //single sample impulses, this generates an impulse every second
```
Also useful are Trig and Trig1.  Trig's first argument is an input signal and its second a duration.  When the input passes from nonpositive to positive Trig outputs the level of the input for the specified duration.  This is fantastic for attaching onto complex signals and turning them into wonky clocks.  Trig1 does the same thing but outputs a 1 whenever the boundary is crossed which is probably more useful for sample triggering or envelopes that you don't want scaled to the strength of the trigger. 
```
~sound = {SinOsc.ar(LFNoise0.kr(1).range(100,200))};
~sound.play(0,2)

~trig = {Trig.ar(~sound,0.1) * FSinOsc.ar(800,0.5)};
~trig.play(0,2);
~sound.stop;
~trig.stop;
```
You will notice that Trig1 can also be used as a gate with its duration argument.

The simplest gate to use, however, is "Pulse".  This would be a better choice if you wanted a randomly timed gates with variable duration.  It would take few lines of code anyway.  This is covered in the follwoing SC files but i'll put an example here too
```
//a simple gate of one cycle a second with a pulse width of 0.5
~gate = {Pulse.kr(1,0.5)}; 

//a more complex gate capable of being modulated
(
~gate = {arg modFreq = 0.5;
	var pulse = LFNoise0.ar(1).range(0.25,0.9);
	var freq = SinOsc.ar(modFreq).range(0.5,2);
	Pulse.kr(freq,pulse)};
)
```
When used in ProxySpace these functions can easily be plugged into other UGens with gate or trigger arguments:
```
~saw = {
	arg atk = 0.1, dec = 0.1;
	Saw.ar([220,222]) * EnvGen.ar(Env.asr(atk,0.5,dec),~gate)};
```
