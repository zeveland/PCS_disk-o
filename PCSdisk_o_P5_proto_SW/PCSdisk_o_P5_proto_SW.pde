
import processing.serial.*;

Serial myPort;  // Create object from Serial class


  
int rings[] = {1, 6, 12, 20, 24, 28, 32, 40, 44, 48};
float outerDiameter = 0;
float outerRadius = 0;
float circleOriginX = 0;
float circleOriginY = 0;
int ringCount = 10;
int loopCount = 0;
boolean goingOut = true;
Dot dots[] = new Dot[255];
float sweepAngle = 0;

void setup() {
  size(2048, 1536);
//  size(1024, 768);
  outerDiameter = height * 0.9;
  outerRadius = outerDiameter / 2;
  circleOriginX = width/2;
  circleOriginY = height/2;
  
  int n=255;
  for (int r=0; r<10; r++) {
    float diameter = outerDiameter * ((float)r/ringCount);    

    for (int p=0; p<rings[r]; p++) {
      float x = circleOriginX - ((diameter/2) * cos(radians((float)360 * (rings[r] - p)/rings[r] + 90) - radians((float)360/rings[r])));
      float y = circleOriginY - ((diameter/2) * sin(radians((float)360 * (rings[r] - p)/rings[r] + 90) - radians((float)360/rings[r])));
      float d = (float)outerDiameter/25;
      dots[n-1] = new Dot(n, x, y, d);
      n--;
    }
  }
  
  String portName = Serial.list()[0];
  println(portName);
  myPort = new Serial(this, portName, 9600);
  
  frameRate(15);
}

long lastUpdate = 0;

void draw() {
  background(0);
  stroke(255);
  fill(0);
  
  stroke(0, 255, 0);
  strokeWeight(5);
  
//  float sweepEndX = circleOriginX - (outerRadius * cos(radians(sweepAngle)));
//  float sweepEndY = circleOriginY - (outerRadius * sin(radians(sweepAngle)));
//  line(circleOriginX, circleOriginY, sweepEndX, sweepEndY);
//  sweepAngle += 0.5; 
  
  boolean sendSerial = false;
  if (millis() - lastUpdate > 1000) {
    sendSerial = true;
    lastUpdate = millis();
  }
  
  for (int i=0; i<255; i++) { 
    dots[i].update();
    if (sendSerial == true) {
      dots[i].sendSerial();
    }
  }

  

  /*
  if (true == goingOut) {
    loopCount++;
    if (loopCount >= 180) {
      goingOut = false;
    }
  } else {
    loopCount--;
    if (loopCount <= 0) {
      goingOut = true;
    }
  }  
  */
}

class Dot {
  int n;    // dot number
  float x;  // x coordinate of dot center
  float y;  // y coordinate of dot center
  float d;    // dot diamter
  float b;    // dot brightness
  
  Dot(int _n, float _x, float _y, float _d) {
    n = _n;
    x = _x;
    y = _y;
    d = _d;
    b = random(255);
  }
  
  void update() {
    strokeWeight(1);
    if (b>255) {
      fill(510-b);
    } else {
      fill(b);
    }
    stroke(0);
    ellipse(x, y, d, d);
    textSize(10);

    stroke(255);
    fill(255, 0, 0);
    text(n, x-5, y+5);
    b += 1 + random(-1, 1);
    b %= 510;
  }
  
  void sendSerial() {
    int _b = 0;
    if (b>255) {
//      fill(510-b);
      _b = ((510-(int)b)<<16) + ((510-(int)b)<<8) + (510-(int)b);
    } else {
//      fill(b);
      _b = (((int)b<<16) + ((int)b<<8) + (int)b);
    }
    
    String s = '*' + hex(n, 2) + ':' + hex(_b, 6);
//    myPort.write('*' + hex(n) + ':' + hex(_b));
//    println(hex(n) + " " + hex(_b));
//    println(s);
    myPort.write(s);
  }
}
