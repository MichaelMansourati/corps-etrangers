/*
instruments are all designated unique busses
we apply and replace synths on busses to change their sounds

- add some Synthdefs to play
- every rrand(x, y) seconds, change to a different sound
- apply this to two busses
*/
~setup.value(6)

~instGroups[2] = Group.new;
x = ~worms.value(~instBusses[2], ~instGroups[2]);
~instGroups[2].set(\gate, 0);
x;

~instGroups[2].freeAllMsg;
x.stop;

/*
make a pattern(? probably? or maybe a routine?) that randomly selects from array of _____s
to play for a random amount of time.
*/
(
~theScore = {

	Pbind(
		\instrument, Prand([\randomDrum])
	).play
}
)

