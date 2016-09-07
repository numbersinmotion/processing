int countFrames = 80;
boolean saveFrames = false;
int countSegments = 5000;
int countCircles = 12;
float circleRadius = 175;
float circleAmplitude = 100;
float noiseResolution = 0.5;
float noiseAmplitude = 1.5;
  
  int curl = -8;
  float twistAmplitude = 1;
  int wrap = 6;
  
void setup() {
  size(640, 640, P3D);
  hint(ENABLE_STROKE_PURE);
  smooth(8);
  colorMode(HSB, 100);
  noiseSeed(420420);
}
void draw() {
  background(0, 0, 0);
  float sceneRatio = (float(frameCount) - 1) / countFrames;
  translate(width / 2, height / 2 - 35);
  rotateX(PI / 5);
  lights();
  
  for (int c = 0; c < countCircles; c++) {
    for (int s = 0; s < countSegments; s++) {
      
      float theta_1 = map(s, 0, countSegments, 0, 2 * PI);
      float noise_1 = noise(noiseResolution * cos(theta_1) + noiseResolution, noiseResolution * sin(theta_1) + noiseResolution);
      float modNoise_1 = sin(2 * PI * (noiseAmplitude * noise_1 + sceneRatio));
      float phi_1 = curl * 2 * PI * sceneRatio / countCircles + map(c, 0, countCircles, 0, 2 * PI) + twistAmplitude * modNoise_1 + wrap * theta_1 / countCircles;
      float radius_1 = circleRadius + circleAmplitude * cos(phi_1);
      float x_1 = radius_1 * cos(theta_1);
      float y_1 = radius_1 * sin(theta_1);
      float z_1 = circleAmplitude * sin(phi_1);
      
      float theta_2 = map(s + 1, 0, countSegments, 0, 2 * PI);
      float noise_2 = noise(noiseResolution * cos(theta_2) + noiseResolution, noiseResolution * sin(theta_2) + noiseResolution);
      float modNoise_2 = sin(2 * PI * (noiseAmplitude * noise_2 + sceneRatio));
      float phi_2 = curl * 2 * PI * sceneRatio / countCircles + map(c, 0, countCircles, 0, 2 * PI) + twistAmplitude * modNoise_2 + wrap * theta_2 / countCircles;
      float radius_2 = circleRadius + circleAmplitude * cos(phi_2);
      float x_2 = radius_2 * cos(theta_2);
      float y_2 = radius_2 * sin(theta_2);
      float z_2 = circleAmplitude * sin(phi_2);
      
      float theta_3 = map(s + 1, 0, countSegments, 0, 2 * PI);
      float noise_3 = noise(noiseResolution * cos(theta_3) + noiseResolution, noiseResolution * sin(theta_3) + noiseResolution);
      float modNoise_3 = sin(2 * PI * (noiseAmplitude * noise_3 + sceneRatio));
      float phi_3 = curl * 2 * PI * sceneRatio / countCircles + map(c + 1, 0, countCircles, 0, 2 * PI) + twistAmplitude * modNoise_3 + wrap * theta_3 / countCircles;
      float radius_3 = circleRadius + circleAmplitude * cos(phi_3);
      float x_3 = radius_3 * cos(theta_3);
      float y_3 = radius_3 * sin(theta_3);
      float z_3 = circleAmplitude * sin(phi_3);
      
      float theta_4 = map(s, 0, countSegments, 0, 2 * PI);
      float noise_4 = noise(noiseResolution * cos(theta_4) + noiseResolution, noiseResolution * sin(theta_4) + noiseResolution);
      float modNoise_4 = sin(2 * PI * (noiseAmplitude * noise_4 + sceneRatio));
      float phi_4 = curl * 2 * PI * sceneRatio / countCircles + map(c + 1, 0, countCircles, 0, 2 * PI) + twistAmplitude * modNoise_4 + wrap * theta_4 / countCircles;
      float radius_4 = circleRadius + circleAmplitude * cos(phi_4);
      float x_4 = radius_4 * cos(theta_4);
      float y_4 = radius_4 * sin(theta_4);
      float z_4 = circleAmplitude * sin(phi_4);
      
      noStroke();
      if (c % 2 == 0) {
        fill(map(cos(theta_1 + map(z_1, -circleAmplitude, circleAmplitude, -PI, PI) + 2 * PI * sceneRatio), -1, 1, 70, 85), 100, 100);
        noStroke();
        beginShape();
          vertex(x_1, y_1, z_1);
          vertex(x_2, y_2, z_2);
          vertex(x_3, y_3, z_3);
        endShape();
        beginShape();
          vertex(x_3, y_3, z_3);
          vertex(x_4, y_4, z_4);
          vertex(x_1, y_1, z_1);
        endShape();
      }
      else {
        fill(0, 0, 0);
        noStroke();
      beginShape();
        vertex(x_1, y_1, z_1);
        vertex(x_2, y_2, z_2);
        vertex(x_3, y_3, z_3);
        normal(0, 0, 1);
      endShape();
      beginShape();
        vertex(x_3, y_3, z_3);
        vertex(x_4, y_4, z_4);
        vertex(x_1, y_1, z_1);
        normal(0, 0, 1);
      endShape();
      }
    }
  }
  
  if (saveFrames) {
    if (frameCount <= countFrames) {
      saveFrame("f###.jpg");
    }
    else {
      exit();
    }
  }
}
