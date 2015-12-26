// a fantastic library by Lee Byron //
// http://leebyron.com/mesh/ //
import megamu.mesh.*;

String image_file = "image.jpg";
int countPoints = 1000;

PImage img;
int[] mapPixels;
float[][] points = new float[countPoints][3];
ArrayList<int[]> faces = new ArrayList<int[]>();

void setup() {
  
  size(1000, 750, P3D);
  hint(ENABLE_STROKE_PURE);
  smooth(8);
  noLoop();
  
  // scale/resize image and load into memory //
  img = loadImage(image_file);
  if (width <= height) img.resize(0, height);
  else img.resize(width, 0);
  img = img.get(img.width / 2 - width / 2, 0, width, height);
  image(img, 0, 0);
  loadPixels();
  
  // generate a random set of points //
  // need to go a little bit outside of the frame //
  // here to ensure the whole image is accounted for //
  for (int i = 0; i < points.length; i++) {
    points[i][0] = 1.5 * width / 2 * random(-1, 1);
    points[i][1] = 1.5 * height / 2 * random(-1, 1);
  }
  
  // get the delaunay triangulation //
  Delaunay myDelaunay = new Delaunay(points);
  float[][] myEdges = myDelaunay.getEdges();
  
  // get the 3 points that define each face //
  for (int i = 0; i < points.length; i++) {
    int[] localLinks = myDelaunay.getLinked(i);
    for (int j = 0; j < localLinks.length; j++) {
      int[] neighborLinks = myDelaunay.getLinked(localLinks[j]);
      for (int k = 0; k < localLinks.length; k++) {
        for (int l = 0; l < neighborLinks.length; l++) {
          if (localLinks[k] == neighborLinks[l] && i < localLinks[j] && localLinks[j] < localLinks[k]) {
            faces.add(new int[]{i, localLinks[j], localLinks[k], 0, 0, 0, 0, ceil(random(0, 1000))});
          }
        }
      }
    }
  }
  
  // determine which face each pixel falls into //
  mapPixels = new int[pixels.length];
  for (int i = 0; i < pixels.length; i++) {
    float x = i % width;
    float y = floor(i / width);
    for (int j = 0; j < faces.size(); j++) {
      int[] face = faces.get(j);
      float x0 = points[face[0]][0] + width / 2;
      float y0 = points[face[0]][1] + height / 2;
      float x1 = points[face[1]][0] + width / 2 - x0;
      float y1 = points[face[1]][1] + height / 2 - y0;
      float x2 = points[face[2]][0] + width / 2 - x0;
      float y2 = points[face[2]][1] + height / 2 - y0;
      float a = (calcDet(x, y, x2, y2) - calcDet(x0, y0, x2, y2)) / calcDet(x1, y1, x2, y2);
      float b = -(calcDet(x, y, x1, y1) - calcDet(x0, y0, x1, y1)) / calcDet(x1, y1, x2, y2);
      if (a > 0 && b > 0 && a + b < 1) {
        mapPixels[i] = j;
        break;
      }
    }
  }
  
  // average the color over all pixels within each face //
  for (int i = 0; i < faces.size(); i++) {
    int face[] = faces.get(i);
    int count = 0;
    int r = 0;
    int g = 0;
    int b = 0;
    for (int j = 0; j < pixels.length; j++) {
      color c = pixels[j];
      if (mapPixels[j] == i) {
        count++;
        r += int(red(c));
        g += int(green(c));
        b += int(blue(c));
      }
    }
    face[3] = count + 1;
    face[4] = r;
    face[5] = g;
    face[6] = b;
    faces.set(i, face);
  }
  
}

void draw() {
  
  // shift image to center //
  translate(width / 2, height / 2);
  
  // draw each face //
  for (int i = 0; i < faces.size(); i++) {
    int[] face = faces.get(i);
    int count = 0;
    int switchCount = 1;
    
    // occasionally some triangles will not get assigned any pixels //
    // when this happens find the closest triangle that does //
    while (face[3] == 1 && face[4] == 0 && face[5] == 0 && face[6] == 0) {
      if (i + count == faces.size() - 1) {
        count = 0;
        switchCount = -1;
      }
      count++;
      face = faces.get(i + switchCount * count);
    }
    
    // draw the triangle //
    noStroke();
    fill(face[4] / face[3], face[5] / face[3], face[6] / face[3]);
    pushMatrix();
      beginShape();
        for (int k = 0; k < 3; k++) {
          vertex(points[face[k]][0], points[face[k]][1]);
        }
      endShape(CLOSE);
    popMatrix();
  }
  
  // save the frame //
  saveFrame("out_" + countPoints + ".jpg");
  
}

// calculates the determinate of two vectors //
float calcDet(float _x1, float _y1, float _x2, float _y2) {
  float _result = _x1 * _y2 - _y1 * _x2;
  return _result;
}
