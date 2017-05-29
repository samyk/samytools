samytools
=========

Tools for console cowboying.

This is a collection of simple but effective tools to use on the command line to improve computing.

--------

**3** - combined calculator and base converter

**GET** - HTTP GET

**aes** - encrypt/decrypt message with AES
`aes 9E38A1CACF2E2AEB2393ABA2AD9582D3 1CF7E85AFE548262CCAE0F1A5F181799`

**aire** - (OS X) reset wifi
`aire` # network will disconnect temporary

**alert** - alert (play sound) when a command completes
`alert dd if=file.iso of=disk`

**alexa** - get Alexa.com ranking for a site
`alexa cnn.com`

**all** - loop a command over a list of files
`all 'tar -zxvf FILE' *tgz`

**ana** -
**arduino** -
**asm** -
**asm2pl** -
**avg** -
**b2h** -
**b64** -
**baud** -
**bl** -
**ccchanbw** -
**ccdeviatn** -
**ccdrate** -
**ccfreq** -
**char** -
**conv** -
**cpu** -
**de_bruijn** -
**desktopinfo** -
**diffbits** -
**diffdir** -
**disable_swap** -
**dos2unix** -
**ds** -
**exp** -
**g** -
**gcode-xbox** -

**hex2bin** -

**ip** - list IPv4 addresses, interface name and default gateway
`ip` # list all IPs, interfaces, and gateway
`ip en0` # only list IP of en0 interface

**ipfwd** - (OS X) enable/disable IP forwarding, temporarily or permanently
`ipfwd 1` # enable ip forwardwing
`ipfwd 0` # disable ip forwardwing
`ipfwd 5 10` # enable for 5 seconds, disable for 10 seconds, enable on exit

**onchange** - run a command whenever a file/directory changes
`onchange . rsync -av ./ remote.com:project

**pb2url** -
**pi** -
**pm3cs8** -
**pmi** -
**pn9** -
**rtl** -
**same** -
**sdi** -
**sdr** -
**serialsniff** -
**sik** -
**siteinfo** -
**spec** -
**strace** -
**teensy** -
**testpb** -
**timer** -
**tm** -
**unm** -
**unz** -
**ur** -
**url_sniff** -
**watch** -
**whiten** -
**wx** -
**xor** -


**rtl** - uses rtl\_fm or hackrf\_fm to listen to a frequency, with a default of AM modulation and a high sample rate.

*`usage: rtl [-s squelch] [-m modulation] [-b (baudline)] [-l (lowpass)] <frequency (hz/mhz)> [file.wav]`*

**`rtl 315M`** listens at 315M with AM modulation and a sample rate of 2M

**`rtl 315M test.wav`** saves to test.wav while listening to  15M with AM modulation and a sample rate of 2M

--------
