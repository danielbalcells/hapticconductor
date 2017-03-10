(

SynthDef(\hapticMetronome, {
	arg freq=400,amp=0.5;
	var env, osc;

	env = EnvGen.ar(Env.new(times:[0.1,0.5],curve:'exp'),doneAction:2);

	osc = SinOsc.ar(freq);

	Out.ar(0,osc*amp);

}).add;

)

Synth(\hapticMetronome);
Synth(\hapticMetronome,[\freq,200]);

(
var freqs;

freqs = Array.fill(8, {arg i;
	(62+i).midicps;
});

OSCdef('/HapticBlip', {arg msg,time,addr,recvPort;
	Synth(\hapticMetronome,[\freq,freqs[msg[1]]]);
	msg.postln;
		},"/HapticBlip");

)