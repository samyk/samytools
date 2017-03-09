/*

Serial to PPM - must run on Teensy 3.1+ (maybe 3.0?)
use ./osc2ppm [port] in background to interface with this

-samy kamkar

TODO:
 why does serial sometimes output 0?
 
 Serial input:
 byte <channel 1-16>
 float <us>
 

 # on tigerblood
 ssh -fN -R 19999:localhost:19999 samy.pl
 netcat -uL 127.0.0.1:7777 -p 19999 -t

 # on samy.pl
 /usr/sbin/lsof -n |grep LISTEN|grep :19999|perl -lane'kill 9,$F[1]'
 netcat -L 72.14.179.47:19999 -p 19999 -u # working

 # on tigerblood
 start teensy
 cd ~/code/arduino && ./osc2ppm 7777
 power on orangerx

 # on ipad
 run lemur
 center sticks
 set U to 0.456-0.476 (if still orange, set to 0.500)
 start drone

 ------

 # on ipad
 CENTER THE STICKS
 THEN TURN DRONE ON

 # TROUBLESHOOTING
 drone: Rudder not working or U not working, kill power to orangerx, start power, move sticks
 drone: Flashing orange indefinitely, play with U (try .505 or 0.456-0.476), center sticks, repower orangerx // reconnect battery
 drone: Won't start (not in atti?) Change U to 0.456-0.476

 set control mode to 0.456 - 0.476
 set control mode to 0.497 - 0.538

 cd ~/code/arduino && ./osc2ppm 7777

 # ntsc, cvbs/composite seems best
 somagic-capture -n --luminance=2 --lum-aperture=3 | mplayer -vf yadif,screenshot -demuxer rawvideo -rawvideo "ntsc:format=uyvy:fps=30000/1001" -aspect 4:3 -


 cd ~/code/arduino && ./osc2ppm 7777
 */

#define MAX_SIGNALS 8
#define PPM_PIN 5
#define MIN 1000 // 500
#define MAX 2000 // 2000

#include <PulsePosition.h>

PulsePositionOutput myOut;
byte in;
byte up = 1;

union fb {
  byte b[4]; 
  float f;
};
fb signal[MAX_SIGNALS+1];

void setup()
{
  Serial.begin(115200);
  myOut.begin(PPM_PIN);

  // set mid or low position for everything?
  for (int i = 1; i <= MAX_SIGNALS; i++)
    signal[i].f = MIN;

}

void test()
{
  while (1) { 
    for (int i = 1; i <= 1; i++)
    {
      myOut.write(i, signal[i].f);
      signal[i].f += up ? 1 : -1;
      if (signal[i].f > MAX || signal[i].f < MIN)
        up = !up;
      //        signal[i].f = 1000;
    }
  }
}

void loop()
{
  //  test();

  serialEvent();
  writeSignals();
  //  myOut.write(3, 500);
  //  myOut.write(4, 500);
}


void serialEvent()
{
//  Serial.println("test");
  while (Serial.available() >= 5)
  {
 //   Serial.println("avail");
    
    // get the new byte:
    in = (byte)Serial.read();
    if (in >= 1 && in <= MAX_SIGNALS)
    {
      signal[in].b[0] = (byte)Serial.read();
      signal[in].b[1] = (byte)Serial.read();
      signal[in].b[2] = (byte)Serial.read();
      signal[in].b[3] = (byte)Serial.read();
      
      myOut.write(in, signal[in].f);

    /*
      Serial.print("i=");
      Serial.print(in);
      Serial.print(" f=");
      Serial.println(signal[in].f);
      */
      writeSignals();
    } 
  }
}

void writeSignals()
{
  return;

  for (int i = 1; i <= MAX_SIGNALS; i++)
  {
    myOut.write(i, signal[i].f);
    /*
    Serial.print("out i=");
    Serial.print(i);
    Serial.print(" f=");
    Serial.println(signal[i].f);
    */
  }
}


