samytools
=========

Tools for console cowboying.

This is a collection of typically simple but effective tools to use on the command line to make life easier.

--------

**rtl** - uses rtl\_fm or hackrf\_fm to listen to a frequency, with a default of AM modulation and a high sample rate.

*`usage: rtl [-s squelch] [-m modulation] [-b (baudline)] [-l (lowpass)] <frequency (hz/mhz)> [file.wav]`*

**`rtl 315M`** listens at 315M with AM modulation and a sample rate of 2M

**`rtl 315M test.wav`** saves to test.wav while listening to  15M with AM modulation and a sample rate of 2M

--------
