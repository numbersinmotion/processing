int countFrames = 500;
boolean saveFrames = false;

PImage img;

String filename = "image_2.jpg";
int countSegments = 100;
int countPoints = 5000;
float[][] points = new float[countPoints][4];
float spinRadius = 50;
float noiseResolution = 0.0075;
float framePad = 1.1;

void setup() {
  size(1080, 1080);
  hint(ENABLE_STROKE_PURE);
  smooth(8);
  colorMode(HSB, 100);
  randomSeed(420);
  noiseSeed(420);
  img = loadImage(filename);
  img.resize(width, height);
  for (int i = 0; i < countPoints; i++) {
    points[i][0] = random(-framePad * width / 2, framePad * width / 2);
    points[i][1] = random(-framePad * height / 2, framePad * height / 2);
    points[i][2] = random(20, 50);
    points[i][3] = map(noise(noiseResolution * points[i][0] + 666, noiseResolution * points[i][1] + 666), 0, 1, 0, 2 * PI);
  }
}

void draw() {
  background(0, 0, 0);
  float sceneRatio = (float(frameCount) - 1) / countFrames;
  
  translate(width / 2, height / 2);
  
  for (int n = 0; n < countPoints; n++) {
    float x = points[n][0] + 2 * points[n][2] * cos(2 * 2 * PI * sceneRatio + points[n][3]);
    float y = points[n][1] + 2 * points[n][2] * sin(2 * 2 * PI * sceneRatio + points[n][3]);
    float r = points[n][2];
    for (int i = 0; i < countSegments; i++) {
     noStroke();
     fill(img.get(int(r * cos(map(i, 0, countSegments, 0, 2 * PI)) + x + width / 2), int(r * sin(map(i, 0, countSegments, 0, 2 * PI)) + y + height / 2)), 75);
     pushMatrix();
       translate(x, y);
       rotate(points[n][3] / 5 * sin(2 * PI * sceneRatio + points[n][3] / 5));
       translate(-x, -y);
       arc(x, y, 2 * r, 2 * r, map(i, 0, countSegments, 0, 2 * PI), map(i + 2, 0, countSegments, 0, 2 * PI));
     popMatrix();
    }
  }

  if (saveFrames) {
    if (frameCount <= countFrames) {
      saveFrame("f###.png");
    }
    else {
      exit();
    }
  }
}
// convert -delay 3 -loop 0 f*.gif animation.gif //
