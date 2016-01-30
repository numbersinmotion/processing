int frameSize = 500;
int countFrames = 40;
boolean saveFrames = true;
int n = 500;
IntList[] hailstone = new IntList[n];
float radius, angle, x, y, dRadius;
int countEvens;

void setup() {
  size(frameSize, frameSize);
  colorMode(HSB, 100);
  strokeWeight(1);
  strokeJoin(ROUND);
  strokeCap(SQUARE);
  noFill();
  for (int i = 0; i < n; i++) {
    hailstone[i] = collatz(ceil(random(1, 2000000)));
  }
}

void draw() {
  background(0);
  for (int i = 0; i < n; i++) {
    radius = 0;
    angle = 0;
    x = frameSize / 2;
    y = frameSize / 2;
    dRadius = (frameSize / 2) / hailstone[i].size();
    countEvens = 0;
    for (int j = 0; j < hailstone[i].size(); j++) {
      if (hailstone[i].get(j) % 2 == 0) {
        countEvens = countEvens + 1;
      }
    }
    stroke(map(float(countEvens) / hailstone[i].size(), .5, .75, 0, 100), 100, 100, 25);
    hailstone[i].sort();
    beginShape(LINES);
    for (int j = 0; j < hailstone[i].size(); j++) {
      if (float(j) / hailstone[i].size() < map(-cos((frameCount - 1) * (2 * PI / countFrames)), -1, 1, 0, 1)) {
        vertex(x, y);
        radius = j * dRadius;
        if (hailstone[i].get(j) % 2 == 0) {
          angle = angle + (1 / (3 * PI * log(2)));
        }
        else {
          angle = angle - (1 / (3 * PI * log(3)));
        }
        x = (frameSize / 2) + (radius * cos(angle + map(-cos((frameCount - 1) * (2 * PI / countFrames)), -1, 1, 0, PI)));
        y = (frameSize / 2) + (radius * sin(angle + map(-cos((frameCount - 1) * (2 * PI / countFrames)), -1, 1, 0, PI)));
        vertex(x, y);
      }
    }
    endShape();
  }
  if (saveFrames) {
    saveFrame("f###.gif");
    if (frameCount == countFrames) {
      exit();
    }
  }
}

IntList collatz(int numInput) {
  IntList collatz;
  collatz = new IntList();
  collatz.append(numInput);
  while(collatz.hasValue(1) == false) {
    if (collatz.get(collatz.size() - 1) % 2 == 0) {
      collatz.append(collatz.get(collatz.size() - 1) / 2);
    }
    else {
      collatz.append((3 * collatz.get(collatz.size() - 1)) + 1);
    }
  }
  collatz.reverse();
  return collatz;
}
