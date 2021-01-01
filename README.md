# cor(p)s-etrangers

*Cor(p)s étrangers* is a collaborative sonic/musical research project started by Emmanuel Madan and Michael Mansourati. The assorted files in this repository are sonic "toys" built in SuperCollider intended to be used as tools for discovering, mapping, and eking out the acoustic idiosyncracies of various low-end brass instruments, i.e tubas.

## testing the latest work
1. in your terminal, in this directory, run:
```
git checkout control-centre
```

2. then open `controlCentre.scd` and `pitchModulation.scd`
3. run the first two (...) blocks in `controlCentre.scd`
4. run the first two (...) blocks in `pitchModulation.scd`
5. run the three functions calls assigned to a, b, and c near the bottom of `pitchModulation.scd`
6. when you want to stop, you can run the `[...].do{...};` line at the bottom to gracefully free the Pmonos and synths