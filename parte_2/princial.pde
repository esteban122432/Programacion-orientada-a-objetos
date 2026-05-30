Movil[][] estacionamiento;
int filas = 2;
int columnas = 3;
int tamCelda = 150;
void setup() {
  size(800, 600);
  estacionamiento = new Movil[filas][columnas];
  for (int f = 0; f < filas; f++) {
    for (int c = 0; c < columnas; c++) {
      float x = 100 + c * tamCelda;
      float y = 100 + f * tamCelda;
      estacionamiento[f][c] = new Movil(x, y, random(-3, 3), random(-3, 3));
    }
  }
}
void draw() {
  background(255);

  for (int f = 0; f < filas; f++) {
    for (int c = 0; c < columnas; c++) {
      noFill();
      rect(75 + c * tamCelda, 75 + f * tamCelda, tamCelda, tamCelda);
    }
  }
  for (int f = 0; f < filas; f++) {
    for (int c = 0; c < columnas; c++) {
      estacionamiento[f][c].mover();
      estacionamiento[f][c].mostrar();
    }
  }
}
