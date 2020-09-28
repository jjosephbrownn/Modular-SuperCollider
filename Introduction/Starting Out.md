## How to Have Fun

All of the files included in this repo can be copied directly into supercollider and run without any further installations.  Most of the files have a audio driver option at the beginning because I like to run ASIO as Windows' MME is garbage.  You can skip this if you can't be bothered but I would recommend checking those options out.  Google "SuperCollider audio driver options" to find the specific syntax for whatever driver you'd like to use. 

I'm fairly sure this should work on all systems... I wrote it all on Windows (fight me) and havn't checked it but i'm not aware of any important differences in the actual code between different operating systems.

Most of these examples use ProxySpace which is an environment within SC that allows you to write synths on the fly, edit and re-evaluate them and plug them into one another in real time.  To be honest, I'm not 100% on the workings of this environment - it seems fairly complex and its a bit beyond me.  However, because of the ability to quickly change synths while they are still playing while also sending them into other sound sources this environment is perfect for live modular synth coding.  You don't have to understand it to use it!

Each code example will have something like this at the start
```
p=ProxySpace.push(s);
```
which initialises ProxySpace.  Pretty sure none of the examples will work as intended if this isn't evaluated first.

Initialising proxies starts them "playing".  To hear their sound you have to attach them to a bus to be monitored
```
~saw = {Saw.ar([220,222])};
~saw.play;
```
The first line creates and sets off a proxy; the second line plays it.  Call .stop on a proxy to stop monitoring.

The example above has a multichannel expansion in the Saw UGen which plays the sound in stereo.  Writing stereo frequency sources can be tiresome sometimes, especially when the source is another synth.  The syntax can get messy and you end up spending too much time thinking about how to make a simple sound play in both channels.  I usually cheat and do this
```
~saw.play(0,2);
```
play's first argument is the bus to write the signal to, and the second argument is the number of channels within that bus.  Nice and simple stereo.  Avoid piling lots of proxies into the same bus though...
