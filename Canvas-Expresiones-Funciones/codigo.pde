void setup() {
  size(800, 600);
}

void draw() {
  background(150, 200, 255); // cielo

  suelo();
  sol(width*0.8, height*0.2);
  casa(width/2, height*0.65);
}

void suelo() {
  fill(100, 200, 100);
  rect(0, height*0.75, width, height*0.25);
}

void sol(float x, float y) {
  fill(255, 200, 0);
  ellipse(x, y, 80, 80);
}

void casa(float x, float y) {
  fill(200, 100, 100);
  rect(x-50, y-50, 100, 100);

  fill(150, 50, 50);
  triangle(x-60, y-50, x+60, y-50, x, y-100);

  fill(120, 70, 40);
  rect(x-10, y, 20, 50);
}
