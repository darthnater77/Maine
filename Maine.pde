PImage mapImage;
Table locationTable;
Table dataTable;
Table cityTable;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
int counting;

float closestDist;
String closestText;
float closestTextX;
float closestTextY;
float closestPop;
float closestHS;
float closestC;

color population = color(192, 0, 0);
color hsGrad = color(0, 0, 192);
color cGrad = color(0, 255, 0);

void setup() {
  size(475, 662);
  mapImage = loadImage("maine.png");
  locationTable = new Table("cities.tsv");
  rowCount = locationTable.getRowCount();

  dataTable = new Table("mainedata.tsv");
  cityTable = new Table("cityName.tsv");

  for (int row = 0; row < rowCount; row++) {
    float value = dataTable.getFloat(row, 1);
    if (value > dataMax) {
      dataMax = value;
      counting++;
    }
    if (value < dataMin) {
      dataMin = value;
    }
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);
  smooth();
  noStroke();
  drawKey(10, 590, 20);

  closestDist = width*height;

  for (int row = 0; row < rowCount; row++) {
    String abbrev = dataTable.getRowName(row);
    float x = locationTable.getFloat(abbrev, 1);
    float y = locationTable.getFloat(abbrev, 2);
    drawData(x, y, abbrev);
  }

  if (closestDist != width*height) {
    fill(0);
    textBox(325, 100);
  }
}

void drawKey(int x, int y, int step) {
  fill(0);
  text("Legend", x, y);
  text("Population", x+15, y+step);
  text("High School Graduates", x+15, y+step*2);
  text("College Graduates (Bachelor's Degree)", x+15, y+step*3);

  fill(population);
  ellipse(x+5, y+step-5, 10, 10);
  fill(hsGrad);
  ellipse(x+5, y+step*2-5, 10, 10);
  fill(cGrad);
  ellipse(x+5, y+step*3-5, 10, 10);
}

void textBox(int x, int y){
  text("City: " + closestText, x, y);
  text("Population: " + closestPop, x, y+15);
  text("High School Grads: " + closestHS + "%", x, y+30);
  text("College Grads: " + closestC + "%", x, y+45);
}

void drawData(float x, float y, String abbrev) {
  fill(population);
  float value = dataTable.getFloat(abbrev, 1);
  float mapped = map(value, dataMin, dataMax, 20, 50);
  ellipse(x, y, mapped, mapped);
  drawPercents(x, y, abbrev, mapped);

  float d = dist(x, y, mouseX, mouseY);
  if ((d < mapped/2 + 2) && (d < closestDist)) {
    closestDist = d;
    String name = cityTable.getString(abbrev, 1);
    closestText = name;
    closestTextX = x;
    closestTextY = y-(mapped/2)-4;
    closestPop = dataTable.getFloat(abbrev, 1);
    closestHS = dataTable.getFloat(abbrev, 3);
    closestC = dataTable.getFloat(abbrev, 4);
  }
}

void drawPercents(float x, float y, String abbrev, float size) {
  fill(hsGrad);
  float value = dataTable.getFloat(abbrev, 3);
  float mapped = value * size * .01;
  ellipse(x, y, mapped, mapped);

  fill(cGrad);
  value = dataTable.getFloat(abbrev, 4);
  mapped = value * size * .01;
  ellipse(x, y, mapped, mapped);
}

