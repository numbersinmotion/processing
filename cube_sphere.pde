int countFrames = 500;
boolean saveFrames = false;
int countPoints = 30;
float frameRatio = 0.55;

void setup() {
  size(540, 540, P3D);
  hint(ENABLE_STROKE_PURE);
  smooth(8);
  colorMode(HSB, 100);
  ortho();
}

void draw() {
  
  background(0, 0, 0);
  
  float sceneRatio = (float(frameCount) - 1) / countFrames;
  float t = map(sin(2 * PI * sceneRatio), -1, 1, 0, 1);
  
  float d = frameRatio * min(width, height) / 2;
  
  translate(width / 2, height / 2);
  
  rotateX(2 * PI / 2 * sin(2 * PI * sceneRatio) + 2 * PI / 10);
  rotateY(2 * PI / 4 * sceneRatio);
  
  stroke(0, 0, 100);
  fill(0, 0, 0);
  
  for (int i = 0; i < countPoints; i++) {
    for (int j = 0; j < countPoints; j++) {
      
      PVector[][] cubeFace = new PVector[6][4];
      PVector[][] sphereFace = new PVector[6][4];
      PVector[][] lerpFace = new PVector[6][4];
      
      float x1 = map(i, 0, countPoints, -d, d);
      float y1 = map(j, 0, countPoints, -d, d);
      float x2 = map(i + 1, 0, countPoints, -d, d);
      float y2 = map(j, 0, countPoints, -d, d);
      float x3 = map(i + 1, 0, countPoints, -d, d);
      float y3 = map(j + 1, 0, countPoints, -d, d);
      float x4 = map(i, 0, countPoints, -d, d);
      float y4 = map(j + 1, 0, countPoints, -d, d);
      
      PVector[] singleFace = new PVector[4];
      singleFace[0] = new PVector(x1, y1);
      singleFace[1] = new PVector(x2, y2);
      singleFace[2] = new PVector(x3, y3);
      singleFace[3] = new PVector(x4, y4);
      
      for (int n = 0; n < 6; n++) {
        beginShape();
          for (int v = 0; v < 4; v++) {
            if (n == 0 || n == 1) cubeFace[n][v] = new PVector(singleFace[v].x, singleFace[v].y, pow(-1, n) * d);
            if (n == 2 || n == 3) cubeFace[n][v] = new PVector(singleFace[v].x, pow(-1, n) * d, singleFace[v].y);
            if (n == 4 || n == 5) cubeFace[n][v] = new PVector(pow(-1, n) * d, singleFace[v].x, singleFace[v].y);
            sphereFace[n][v] = cubeFace[n][v].copy();
            sphereFace[n][v].setMag(d);
            lerpFace[n][v] = PVector.lerp(cubeFace[n][v], sphereFace[n][v], t);
            vertex(lerpFace[n][v].x, lerpFace[n][v].y, lerpFace[n][v].z);
          }
        endShape(CLOSE);
      }
    }
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
//  convert -delay 3 -loop 0 f*.gif animation.gif  //
