#include <Adafruit_DotStar.h>
#include <SPI.h>

#define NUMPIXELS     255

Adafruit_DotStar strip = Adafruit_DotStar(NUMPIXELS);
char data[9];

void setup() {
  Serial.begin(9600);
  strip.begin();
  strip.show();
} 

void loop() {
  while (Serial.available() < 1) {
    
  }
  int startChar = Serial.read();
  if (startChar == '*') {
    Serial.println("start");
    int count = Serial.readBytes((char *)data, 9);
    if (9 == count) {
      int pos = (int)strtol(&data[0], NULL, 16);
      long val = strtol(&data[3], NULL, 16);
      strip.setPixelColor(pos, val);
      strip.show();
      Serial.print("pos: ");
      Serial.print(pos);
      Serial.print("  val: ");
      Serial.print(val);
      Serial.println();

    } else {
      Serial.println("invalid data");
    }
  } else {
    Serial.print("invalid start char: ");
    Serial.println((char)startChar);
  }
}

