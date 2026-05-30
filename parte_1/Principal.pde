Movil [] moviles;
int cant=5;
void setup() {
  size(800, 600);
  moviles= new Movil[cant];
  float sep=width/cant;
  for (int i=0; i<cant; i++) {
    moviles[i]=new Movil(sep*i, height/cant);
  }
}
void draw() {
  background(#E3E3E3);
  for (int i=0; i<cant; i++) {
    moviles[i].mover();
    moviles[i].mostrar();
    moviles[i].contener();
  }
}
