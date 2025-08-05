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

**all** - loop a command over a list of files
`all 'tar -zxvf FILE' *tgz`

**ana** - 

**appkey** - send keystrokes or shortcut keys to specific app or globally to control them programmatically

**arduino** -

**asm** - compiles, links and executes .asm file via `nasm`
`asm file.asm`

**asm2pl** - convert 8051 asm to perl
`asm2pl <file>`

**avg** - Averages numbers
`avg <numbers> [NUMBERxTIMES] [...]`

**b2h** -

**b64** - Decodes or encodes b64
`b64 <-d | -e> [data | STDIN]`

**baud** - Determines Baudrate based on values.
`baud <bit width[ums]> [bit width...]`

**bl** -
**ccchanbw** -
**ccdeviatn** -
**ccdrate** -
**ccfreq** -
**char** -

**conv** - Media file conversion (mp4, FLV, mov, AIF, flac, mp3, jpg, png, gif, bmp)
`conv <from> <to>`

**cpu** - Unload OSX Crashplan
`cpu`

**de_bruijn** - De Bruijn Sequence Generator
`de_bruijn <alpha> <nums>`

**desktopinfo** -

**diffbits** - Diff two equal length (per row) sets of binary data
`diffbits <1> <2>`

**diffdir** - Diff two directories by comparing filenames rather than contents
`diffdir <1> <2>`

**disable_swap** - Disables OSX dynamic_pager and removes vm/swapfile
`disable_swap`

**dos2unix** -
**ds** -
**exp** -

**g** - grep++
`g [files] [-aoRz] [-n <file match>] [-i=file] [-e=file] [-options] <match> [-v !match] [-x <cmd, eg ls -lh>]`

**gcode-xbox** - control Grbl-based CNC machine (Carvey, X-Carve, etc) from an Xbox controller
`gcode-xbox [/dev/cu.GRBL_SERIAL_PORT]`

**hex2bin** - convert intel hex file to binary
`hex2bin <file>`

**ip** - list IPv4 addresses, interface name and default gateway
`ip` # list all IPs, interfaces, and gateway
`ip en0` # only list IP of en0 interface

**ipfwd** - (OS X) enable/disable IP forwarding, temporarily or permanently
`ipfwd 1` # enable ip forwardwing
`ipfwd 0` # disable ip forwardwing
`ipfwd 5 10` # enable for 5 seconds, disable for 10 seconds, enable on exit

**j** - join multiple arguments or stdin together into single string with optional join parameter
```
tigerblood:/b$ j 0 1 1 1 1 0 0 1 0 1 1 0 1 1 1 1
0111100101101111

tigerblood:/b$ j -s ,
first
second
third
first,second,third
```

**nocolor** - removes color from piped input, useful if you're trying to parse data where color codes are interfering
`command_that_has_colored_output | nocolor | grep something`

**ocr** - converts image (local file or url) to text via tesseract, cleans up the image first via imagemagick
`ocr https://samy.pl/code.png > code.txt`
`ocr passwords.png > passes.txt`

**onchange** - run a command whenever a file/directory changes
`onchange . rsync -av ./ remote.com:project`

**pb2url** - 
**pi** -

**pm3cs8** - Convert proxmark3 trace to cs8 (complex int8/hackrf fmt) for inspectrum
`pn9 <pm3.trace/file.wav>`

**pmi** -
**pn9** - 

**rtl** - make listening/saving data from rtl-sdr or hackrf faster
`rtl -f 314M -M raw -s 2000000 out.raw`

**same** - look for files that are identical (quickly)
`same [-e match-regexp] [-v ignore-regexp] <dir> [...]`

**sdi** -
**sdr** -

**serialsniff** - (OSX) Sniffs a serial Connection. Prints all unprintable characters!
`serialsniffer <serial device>`

**sik** -
**siteinfo** - 

**spec** - spectrum analyzer (gpu accelerated)
`spec <input>`

**strace** - dtrace wrapper
`strace [-acdefholLs] [-t syscall] { -p PID | -n name | command }`

**teensy** -
**testpb** -
**timer** -
**tm** -
**unm** -

**unpack** - recursively unpack a file and any archives it contains
- useful for files like .pkg that are xar archives containing further gz/cpio archives
- this will not only unpack the primary file (zip/bz2/gz/tar/cpio/xar/gz/7z/xz) but also all packed/archived files contained
`unpack .` - look for any archives in our dir
`unpack -v archive.tar.gz` - verbose

**unz** - Runs lzma on multiple files
`unz <file1> <file2> `

**ur** -
**url_sniff** -
**watch** -
**whiten** -

**wx** - wget's and unpacks files
`wx <url>`

**xor** - XOR Encode/Decode
`xor [-d | -x] <file1 | data1> <file2 | data2>`

**rtl** - uses rtl\_fm or hackrf\_fm to listen to a frequency, with a default of AM modulation and a high sample rate.

*`usage: rtl [-s squelch] [-m modulation] [-b (baudline)] [-l (lowpass)] <frequency (hz/mhz)> [file.wav]`*

**`rtl 315M`** listens at 315M with AM modulation and a sample rate of 2M

**`rtl 315M test.wav`** saves to test.wav while listening to  15M with AM modulation and a sample rate of 2M

--------
