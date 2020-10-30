# Sequencers

Ok so SuperCollider comes with some in-built sequencing tools called Patterns, like Pbind, Pseq etc.  From the SuperCollider documentation:

```
Pbind(\freq, Prand([300, 500, 231.2, 399.2], inf), \dur, 0.1).play;
```

These play SynthDefs which are fun but complex and need to be written before any sort of live context.  For the purposes of this repository I am going to ignore them as they aren't really fit for the type of compositional techniques we're working with.  With a bit of preparation you can make lots of very complex and quickly wonkable music.  However, its a bit like going to a concert where the musicians have a wonderful array of machines and cables and stuff which they built lovingly in their garage.  We're more the kind of musicians who forgot about the gig and turn up to hit whatever resonant objects they had in their kitchen with whatever solid objects they found in the skip outside.  We build the musical context in situ man.

Also (and this sounds odd) I find Patterns a bit too musical? In the sense that they rely on patterns (duh), metrical arrangements and musical structures generally.  These can be screwed around with but you can't really get away from the initial parameters and conditions.  A more modular approach reduces some of these ideas and you're left with the computer equivalent of voltage, current and unlabelled nobs.  The epistemological nature is removed and you have to fumble around in the dark (with the nobs).  For me personally I find this gets me better results but i'm not claiming it as orthodox - it just works for me because i'm a vague and optimistic person.

Anyway, *sequencers*.  These tutorials run off a cool thing I found which doesn't seem to get much love: Demand Rate.  My JavaScript head keeps wanting SuperCollider to define a function or job and then execute it (by name) whenever I tell it to.  The function would have a series of pitches and when triggered it would fire the next one out and then wrap round to the beginning again.  Unfortunately SC doesn't really work like that but Demand Rate offers something a bit similar.

Without going into what a "demand rate" value is (the documentation is very obscure at this point) a basic sequencer would have a Demand.kr that calls a UGen specified as its third argument when it is triggered (by anything).  The UGen has to be demand rate also - these are fairly familiar as they look a lot like Pseq, Prand etc.  Basically any pattern UGen probably has a demand UGen equivalent: Drand, Dwhite, Dseq.

```
(  
~step = {  
	arg notes,freq;  
	notes = Drand([100,200,300,400,500,600],inf);  
	freq = Demand.kr(~clock,0,notes)};  
)
```

This is a simple random sequencer.  The pitches are chose from the Drand UGen which cycles infinitely in a similar way to Prand.  Demand.kr is triggered by ~clock (which could be any trigger or clock signal) and Drand UGen is called, firing out a random pitch from the array.  In Proxy Space this could then be plugged into some sort of sound object as the output of ~step is a control rate value.  (The second argument is a reset value which can be used to start the UGens again.  I just set this to 0 as I always write my earlier demand UGens to cycle until I tell them to stop).

```
(
~harp = {
	var osc,env;
	env = EnvGen.kr(Env.adsr(0.005,0.25,0.25,0.1),~clock)
	osc = Resonz.ar(Pulse.ar(~step.kr, 0.5) * env,Latch.kr(LFNoise0.kr(1).range(100,1000),~clock),0.5)};
)
```

Apart from the obvious selection of pitches this could be used to trigger samples (using a sort of "on off" system of 0s and 1s) or mutate other clocks and synths in inventive ways I havent thought of yet.

I messed around a lot with this and I've found it to be both the most interesting and simplest way of sequencing in SC.  Pbinds require a SynthDefs which can be complex and time consuming and the marsh of Routines gets too abstract too quickly (and also requires a hell of a lot of code).  This method for me sits in a comfortable middle position - it allows you to sequence hastily written sound sources while offering a nice amount of musical structure.  Remember, we're trying to emulate modular synthesis performance - sometimes its better to start from scratch.



