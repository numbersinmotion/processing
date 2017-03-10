int countFrames = 200;
boolean saveFrames = false;
int countSegments = 1000;
int countCircles = 5;
float circleRadius = 150;
float noiseResolution = 2;
float noiseAmplitude = 50;
void setup() {
  size(500, 500);
  hint(ENABLE_STROKE_PURE);
  smooth(8);
  colorMode(HSB, 100);
  noiseSeed(420);
}
void draw() {
  background(0, 100, 0);
  float sceneRatio = (float(frameCount) - 1) / countFrames;
  translate(width / 2, height / 2);
  for (int c = 0; c < countCircles; c++) {
    stroke(0, 0, 100);
    strokeWeight(3);
    noFill();
    beginShape();
      for (int s = 0; s < countSegments; s++) {
        float theta = map(s, 0, countSegments, 0, 2 * PI);
        float noise = noise(noiseResolution * cos(theta) + noiseResolution, noiseResolution * sin(theta) + noiseResolution);
        float modNoise = map(pow(map(sin(2 * PI * (noise + map(theta + 2 * PI * sceneRatio, 0, 2 * PI, 0, 1) + map(c, 0, countCircles, 0, 1) + sceneRatio)), -1, 1, 0, 1), 2), 0, 1, -1, 1);
        float radius = circleRadius + map(modNoise, -1, 1, -noiseAmplitude, noiseAmplitude);
        float x = radius * cos(theta);
        float y = radius * sin(theta);
        vertex(x, y);
      }
    endShape(CLOSE);
  }
  if (saveFrames) {
    if (frameCount <= countFrames) {
      saveFrame("f###.gif");
    }
    else {
      exit();
    }
  }
}
