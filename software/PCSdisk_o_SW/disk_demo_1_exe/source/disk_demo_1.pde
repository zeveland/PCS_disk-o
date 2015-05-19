
//int rings[] = {48, 44, 40, 32, 28, 24, 20, 12, 6, 1};  
int rings[] = {1, 6, 12, 20, 24, 28, 32, 40, 44, 48};
float outerDiameter = 0;
float outerRadius = 0;
float circleOriginX = 0;
float circleOriginY = 0;
int ringCount = 10;
int loopCount = 0;
boolean goingOut = true;

void setup() {
  size(2048, 1536);
  outerDiameter = height * 0.9;
  outerRadius = outerDiameter / 2;
  circleOriginX = width/2;
  circleOriginY = height/2;
  frameRate(30);
}

void draw() {
  background(0);
  stroke(255);
  fill(0);
  
  int dotPos = 255;
  
  for (int r=0; r<10; r++) {
    float diameter = outerDiameter * ((float)r/ringCount);
    float brightness = ((sin(radians(loopCount))+0.5)*255) - (255*(float)r/10);

    for (int p=0; p<rings[r]; p++) {
      fill(brightness);
      float x = (diameter/2) * cos(radians((float)360/rings[r])*p);
      float y = (diameter/2) * sin(radians((float)360/rings[r])*p);
      ellipse(circleOriginX-x, circleOriginY-y, outerDiameter/25, outerDiameter/25);
      textSize(10);
      stroke(255);
      fill(255);
      text(dotPos, circleOriginX-x-5, circleOriginY-y+5);
      dotPos--;
    }
  }
  
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
  
}
