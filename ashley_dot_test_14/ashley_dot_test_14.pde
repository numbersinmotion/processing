int countFrames = 500;
boolean saveFrames = false;
PImage img;
float[][] circles;
float xOffset, yOffset;

String filename = "image_1.jpg";

void setup() {
  size(1000, 1000, P3D);
  hint(ENABLE_STROKE_PURE);
  smooth(8);
  colorMode(HSB, 100);
  ortho();
  img = loadImage(filename);
  img.resize(width, height);
  String[] lines = loadStrings("mytxtfile.txt");
  circles = new float[lines.length][3];
  for (int i = 0; i < lines.length; i++) {
    String[] data = split(lines[i], '\t');
    circles[i][0] = float(data[0]);
    circles[i][1] = float(data[1]);
    circles[i][2] = float(data[2]);
    xOffset += float(data[0]);
    yOffset += float(data[1]);
  }
}

void draw() {
  background(0, 100, 0);
  float sceneRatio = (float(frameCount) - 1) / countFrames;
  translate(width / 2 - xOffset / circles.length, height / 2 - yOffset / circles.length);
  for (int i = 0; i < circles.length; i++) {
    noStroke();
    fill(img.get(int(circles[i][0] + width / 2 - xOffset / circles.length + 25), int(circles[i][1] + height / 2 - yOffset / circles.length - 75)));
    pushMatrix();
      rotateY(PI * ease("easeInOutSine", sceneRatio, 0, 1, 1));
      translate(map(ease("easeInOutSine", sceneRatio, 0, 1, 1), 0, 1, 1, -1) * circles[i][0], circles[i][1], map(noise(circles[i][0], circles[i][1]), 0, 1, -width / 2, width / 2));
      sphere(circles[i][2]);
    popMatrix();
  }
  
  if (saveFrames) {
    if (frameCount <= countFrames) {
      saveFrame("f###.png");
    }
    else {
      exit();
    }
  }
  else if (frameCount == countFrames) frameCount = 0;
}
//  convert -delay 3 -loop 0 f*.gif animation.gif  //

PVector arbitraryAxisRotation(PVector vector, PVector axis, float theta) {
  PVector result = new PVector(0, 0, 0);
  float x = vector.x;
  float y = vector.y;
  float z = vector.z;
  float u = axis.x;
  float v = axis.y;
  float w = axis.z;
  result.x = u * (u * x + v * y + w * z) * (1 - cos(theta)) + x * cos(theta) + (-w * y + v * z) * sin(theta);
  result.y = v * (u * x + v * y + w * z) * (1 - cos(theta)) + y * cos(theta) + (w * x - u * z) * sin(theta);
  result.z = w * (u * x + v * y + w * z) * (1 - cos(theta)) + z * cos(theta) + (-v * x + u * y) * sin(theta);
  return result;
}

// t: current time, b: beginning value, c: change in value, d: duration //
float ease(String function, float t, float b, float c, float d) {
  
  float out = 0;
  
  // ~~~~~~~~ SINE ~~~~~~~~ //
  if (function == "easeInSine") out = -c * cos(t / d * PI / 2) + c + b;
  else if (function == "easeOutSine") out = c * sin(t / d * PI / 2) + b;
  else if (function == "easeInOutSine") out = -c / 2 * (cos(t / d * PI) - 1) + b;
  
  // ~~~~~~~~ QUAD ~~~~~~~~ //
  else if (function == "easeInQuad") out = c * pow(t / d, 2) + b;
  else if (function == "easeOutQuad") out = -c * (t / d) * (t / d - 2) + b;
  else if (function == "easeInOutQuad") {
    if (t / (d / 2) < 1) out = c / 2 * pow(t / (d / 2), 2) + b;
    else out = (-c / 2) * (((t / (d / 2)) - 1) * (((t / (d / 2)) - 2) - 1)) + b + c * 0.5;
  }
  
  // ~~~~~~~~ CUBIC ~~~~~~~~ //
  else if (function == "easeInCubic") out = c * pow(t / d, 3) + b;
  else if (function == "easeOutCubic") out = c * (pow(t / d - 1, 3) + 1) + b;
  else if (function == "easeInOutCubic") {
    t = t / (d / 2);
    if (t < 1) out = c / 2 * pow(t, 3) + b;
    else out = (c / 2) * (pow(t - 2, 3) + 2) + b;
  }
  
  // ~~~~~~~~ QUART ~~~~~~~~ //
  else if (function == "easeInQuart") out = c * pow(t / d, 4) + b;
  else if (function == "easeOutQuart") out = -c * (pow(t / d - 1, 4) - 1) + b;
  else if (function == "easeInOutQuart") {
    t = t / (d / 2);
    if (t < 1) out = c / 2 * pow(t, 4) + b;
    else out = (-c / 2) * (pow(t - 2, 4) - 2) + b;
  }
  
  // ~~~~~~~~ QUINT ~~~~~~~~ //
  else if (function == "easeInQuint") out = c * pow(t / d, 5) + b;
  else if (function == "easeOutQuint") out = c * (pow(t / d - 1, 5) + 1) + b;
  else if (function == "easeInOutQuint") {
    t = t / (d / 2);
    if (t < 1) out = c / 2 * pow(t, 5) + b;
    else out = (c / 2) * (pow(t - 2, 5) + 2) + b;
  }
  
  // ~~~~~~~~ EXPO ~~~~~~~~ //
  else if (function == "easeInExpo") {
    if (t == 0) out = b;
    else out = c * pow(2, 10 * (t / d - 1)) + b;
  }
  else if (function == "easeOutExpo") {
    if (t == d) out = b + c;
    else out = c * (-pow(2, -10 * t / d) + 1) + b;
  }
  else if (function == "easeInOutExpo") {
    if (t == 0) out = b;
    else if (t == d) out = b + c;
    else if (t / (d / 2) < 1) out = c / 2 * pow(2, 10 * (t / (d / 2) - 1)) + b;
    else out = c / 2 * (-pow(2, -10 * (t / (d / 2) - 1)) + 2) + b;
  }
  
  // ~~~~~~~~ CIRC ~~~~~~~~ //
  else if (function == "easeInCirc") {
    out = c * pow(t / d, 3) + b;
  }
  else if (function == "easeOutCirc") {
    out = c * (pow(t / d - 1, 3) + 1) + b;
  }
  else if (function == "easeInOutCirc") {
    t = t / (d / 2);
    if (t < 1) out = c / 2 * pow(t, 3) + b;
    else out = (c / 2) * (pow(t - 2, 3) + 2) + b;
  }
  
  // ~~~~~~~~ BACK ~~~~~~~~ //
  else if (function == "easeInBack") {
    out = c * pow(t / d, 3) + b;
  }
  else if (function == "easeOutBack") {
    out = c * (pow(t / d - 1, 3) + 1) + b;
  }
  else if (function == "easeInOutBack") {
    t = t / (d / 2);
    if (t < 1) out = c / 2 * pow(t, 3) + b;
    else out = (c / 2) * (pow(t - 2, 3) + 2) + b;
  }
  
  else if (function == "easeOutElastic") {
    
    float s = 1.70158;
    float p = 0.3 * d;
    float a = c;
    
    if (a < abs(c)) {
      a = c;
      s = p / 4;
    }
    else s = p / (2 * PI) * asin(c / a);
    
    if (t == 0) out = b;
    else if (t / d == 1) out = b + c;
    else out = a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b;
    
  }
  
  else {
    println("INVALID FUNCTION");
  }
  
  return out;
  
}
