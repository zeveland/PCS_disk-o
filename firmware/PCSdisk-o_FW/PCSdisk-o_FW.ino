#include <Adafruit_DotStar.h>
#include <SPI.h>

#define NUMPIXELS 255

Adafruit_DotStar strip = Adafruit_DotStar(NUMPIXELS);
byte cmd = '0';
int loopCount = 0;

void setup() {
  strip.begin();
  strip.show();
  
  Serial.begin(9600);  
}

void loop() {
  if (Serial.available() > 0) {
    cmd = Serial.read();
    if ((cmd > '4') || (cmd < '0')) {
      cmd = '0';
    }
  }
  
  switch (cmd) {
    case '0':
      allOff();
      break;
    case '1':
      cycleThroughColors();
      break;
    case '2':
      randomFlashes();
      break;
    case '3':
      pieChart();
      break;
    case '4':
      buildToCrescendo();
      break;
  }
}

void allOff() {
  for (int i=0; i<256; i++) {
    strip.setPixelColor(i, 0x000000);
  }
  strip.show();  
}

void cycleThroughColors() {
  long colors[] = {0x6E6E00, 0x006E6E, 0x6E006E, 0x6E6E6E};
  for (int c=0; c<4; c++) {
    for (int i=255; i>-1; i--) {
      strip.setPixelColor(i, colors[c]);
      strip.show();
      delayMicroseconds(500);
    }
    delay(500);
  }
}

void randomFlashes() {
  int pixels[] = {random(255), random(255), random(255), random(255), random(255)};
  for (int i=0; i<5; i++) {
    strip.setPixelColor(pixels[i], random(16777216));
  }
  strip.show();
  delay(3);
  for (int i=0; i<5; i++) {
    strip.setPixelColor(pixels[i], 0x000000);
  }  
}

void buildToCrescendo() {  
  for (int i=0; i<100; i++) {
    // on for 100 ms, off for 400 ms, repeat
    for (int j=0; j<random(i/2, i); j++) {
      strip.setPixelColor(random(255), random(16777216));
    }
    strip.show();
    delay(50);
    for (int j=0; j<256; j++) {
      strip.setPixelColor(j, 0x000000);
    }
    strip.show();
    delay(200);
  }
}

void pieChart() {
  int rings[] = {48, 44, 40, 32, 28, 24, 20, 12, 6, 1};  
  long colors[] = {0x6E6E00, 0x006E6E, 0x6E006E, 0x6E6E6E};
  int sections = 8;
  for (int r=0; r<8; r++) {
    for (int s=0; s<sections; s++) {
      for (int i=(s*rings[r])/sections; i<((s+1)*rings[r])/sections; i++) {
        int distance = 0;
        for (int x=0; x<r; x++) {
          distance += rings[x];
        }
        distance += i;
        strip.setPixelColor(distance, colors[(loopCount+s)%4]);
      }
    }
  }

  strip.show();  
  loopCount++;
  delay(100);
}

