Server.killAll;

(
o = ServerOptions.new;
o.protocol_(\tcp);
t = Server.remote(\raspberryPi, NetAddr("192.168.2.18  ", 57110), o);
t.addr.connect;
t.startAliveThread( 0 );
t.doWhenBooted({ "remote tcp server started".postln; t.notify; t.initTree });
)

~me = NetAddr.new("172.0.0.1", 57120);




