float radio = 25;

float rectX, rectY;
float rectW = 200;
float rectH = 120;

void setup() {
  size(800, 600);

  rectX = width/2 - rectW/2;
  rectY = height/2 - rectH/2;
}

void draw() {
  background(220);

  float cx = mouseX;
  float cy = mouseY;

  boolean colision = detectarColision(cx, cy, radio);

  if (colision) {
    fill(255, 0, 0);
  } else {
    fill(0, 150, 255);
  }

  rect(rectX, rectY, rectW, rectH);

  fill(255);
  ellipse(cx, cy, radio*2, radio*2);
}

boolean detectarColision(float cx, float cy, float r) {

  float cercanoX = constrain(cx, rectX, rectX + rectW);
  float cercanoY = constrain(cy, rectY, rectY + rectH);

  float distancia = dist(cx, cy, cercanoX, cercanoY);

  return distancia <= r;
}
