final int INICIO = 0;
final int FLAPPY = 1;
final int PONG = 2;
final int GAME_OVER = 3;

int estadoDelJuego = INICIO;

ArrayList<DuplaDeTubos> tubos;

Circulo bird;

PVector gravedad = new PVector(0, 0.4);

float ultimoPar = 0;

int puntajeFlappy = 0;


Cuadrado paletaJugador;
Cuadrado paletaCPU;

Circulo pelotaPong;

int puntajeJugador = 0;
int puntajeCPU = 0;



void setup() {

  size(800, 600);

  iniciarFlappy();
  iniciarPong();
}



void draw() {

  if (estadoDelJuego == INICIO) {

    pantallaInicio();
  } else if (estadoDelJuego == FLAPPY) {

    jugarFlappy();
  } else if (estadoDelJuego == PONG) {

    jugarPong();
  } else if (estadoDelJuego == GAME_OVER) {

    pantallaGameOver();
  }
}

void pantallaInicio() {

  background(40, 50, 80);

  textAlign(CENTER, CENTER);

  fill(255);
  textSize(50);
  text("MINI JUEGOS", width/2, 120);

  // Botón Flappy
  fill(80, 200, 100);
  rect(width/2 - 180, 230, 360, 70);

  fill(255);
  textSize(30);
  text("1 - FLAPPY BIRD", width/2, 265);

  // Botón Pong
  fill(80, 130, 220);
  rect(width/2 - 180, 330, 360, 70);

  fill(255);
  textSize(30);
  text("2 - PONG", width/2, 365);

  textSize(18);
  fill(220);
  text("Presioná 1 o 2 para elegir un juego", width/2, 470);
  text("También podés hacer clic en los botones", width/2, 500);
}

void iniciarFlappy() {

  tubos = new ArrayList<DuplaDeTubos>();

  bird = new Circulo(100, height/2);

  ultimoPar = millis();

  puntajeFlappy = 0;
}


void jugarFlappy() {

  background(120, 190, 240);

  agregarTubos();

  bird.addFuerza(gravedad);

  bird.mover();

  for (DuplaDeTubos par : tubos) {

    par.mover();
    par.mostrar();

    if (par.colisiona(bird)) {

      estadoDelJuego = GAME_OVER;
    }
  }

  borrarTubos();

  if (bird.pos.y + bird.tamano/2 >= height ||
    bird.pos.y - bird.tamano/2 <= 0) {

    estadoDelJuego = GAME_OVER;
  }

  bird.mostrar();

  fill(255);
  textAlign(LEFT, TOP);
  textSize(30);
  text("Puntaje: " + puntajeFlappy, 20, 20);
}


void agregarTubos() {

  float tiempoActual = millis();

  float dt = tiempoActual - ultimoPar;

  if (dt > 2500) {

    float gap = 140;

    float altoTop = random(50, height - gap - 50);

    float altoBottom = height - altoTop - gap;

    DuplaDeTubos nuevoPar =
      new DuplaDeTubos(
      width,
      altoTop,
      altoBottom,
      gap
      );

    tubos.add(nuevoPar);

    ultimoPar = tiempoActual;
  }
}


void borrarTubos() {

  for (int i = tubos.size() - 1; i >= 0; i--) {

    DuplaDeTubos par = tubos.get(i);

    if (par.fueraDePantalla()) {

      tubos.remove(i);

      puntajeFlappy++;
    }
  }
}


void pantallaGameOver() {

  background(30);

  textAlign(CENTER, CENTER);

  fill(255, 80, 80);
  textSize(60);
  text("GAME OVER", width/2, 180);

  fill(255);
  textSize(30);

  if (ultimoJuego == FLAPPY) {

    text("Puntaje: " + puntajeFlappy, width/2, 270);
  } else if (ultimoJuego == PONG) {

    text(puntajeJugador + " - " + puntajeCPU, width/2, 270);
  }

  textSize(22);
  text("Presioná ENTER para volver al menú", width/2, 370);
}


int ultimoJuego = FLAPPY;


void iniciarPong() {

  paletaJugador =
    new Cuadrado(
    40,
    height/2 - 60,
    20,
    120
    );

  paletaCPU =
    new Cuadrado(
    width - 60,
    height/2 - 60,
    20,
    120
    );

  pelotaPong =
    new Circulo(
    width/2,
    height/2
    );

  pelotaPong.vel = new PVector(5, 3);

  puntajeJugador = 0;
  puntajeCPU = 0;
}


void jugarPong() {

  background(20);

  stroke(150);
  for (int y = 0; y < height; y += 30) {
    line(width/2, y, width/2, y + 15);
  }

  // Movimiento del jugador
  if (keyPressed) {

    if (key == 'w' || key == 'W') {
      paletaJugador.pos.y -= 6;
    }

    if (key == 's' || key == 'S') {
      paletaJugador.pos.y += 6;
    }
  }

  paletaJugador.pos.y =
    constrain(
    paletaJugador.pos.y,
    0,
    height - paletaJugador.largo
    );

  if (pelotaPong.pos.y > paletaCPU.pos.y + paletaCPU.largo/2) {

    paletaCPU.pos.y += 4;
  } else {

    paletaCPU.pos.y -= 4;
  }

  paletaCPU.pos.y =
    constrain(
    paletaCPU.pos.y,
    0,
    height - paletaCPU.largo
    );


  pelotaPong.mover();

  if (pelotaPong.pos.y - pelotaPong.tamano/2 <= 0 ||
    pelotaPong.pos.y + pelotaPong.tamano/2 >= height) {

    pelotaPong.vel.y *= -1;
  }


  if (pelotaPong.colisiona(paletaJugador)) {

    pelotaPong.vel.x = abs(pelotaPong.vel.x);
  }

  if (pelotaPong.colisiona(paletaCPU)) {

    pelotaPong.vel.x = -abs(pelotaPong.vel.x);
  }

  if (pelotaPong.pos.x < 0) {

    puntajeCPU++;

    reiniciarPelota();
  }
  if (pelotaPong.pos.x > width) {

    puntajeJugador++;

    reiniciarPelota();
  }

  if (puntajeJugador >= 5 || puntajeCPU >= 5) {

    ultimoJuego = PONG;

    estadoDelJuego = GAME_OVER;
  }
  paletaJugador.mostrar();
  paletaCPU.mostrar();
  pelotaPong.mostrar();


  fill(255);
  textAlign(CENTER, TOP);
  textSize(40);

  text(
    puntajeJugador + "     " + puntajeCPU,
    width/2,
    20
    );
}


void reiniciarPelota() {

  pelotaPong.pos.set(width/2, height/2);

  float direccion = random(1) < 0.5 ? -1 : 1;

  pelotaPong.vel =
    new PVector(
    5 * direccion,
    random(-3, 3)
    );
}

void keyPressed() {
  if (estadoDelJuego == INICIO) {

    if (key == '1') {

      iniciarFlappy();

      ultimoJuego = FLAPPY;

      estadoDelJuego = FLAPPY;
    }

    if (key == '2') {

      iniciarPong();

      ultimoJuego = PONG;

      estadoDelJuego = PONG;
    }
  } else if (estadoDelJuego == FLAPPY) {

    if (key == ' ') {

      bird.saltar();
    }

    if (key == ESC) {

      key = 0;

      estadoDelJuego = INICIO;
    }
  } else if (estadoDelJuego == PONG) {

    if (key == ESC) {

      key = 0;

      estadoDelJuego = INICIO;
    }
  } else if (estadoDelJuego == GAME_OVER) {

    if (key == ENTER || key == RETURN) {

      estadoDelJuego = INICIO;
    }
  }
}

void mousePressed() {

  if (estadoDelJuego == INICIO) {
    if (mouseX > width/2 - 180 &&
      mouseX < width/2 + 180 &&
      mouseY > 230 &&
      mouseY < 300) {

      iniciarFlappy();

      ultimoJuego = FLAPPY;

      estadoDelJuego = FLAPPY;
    }

    if (mouseX > width/2 - 180 &&
      mouseX < width/2 + 180 &&
      mouseY > 330 &&
      mouseY < 400) {

      iniciarPong();

      ultimoJuego = PONG;

      estadoDelJuego = PONG;
    }
  }
}

class Cuadrado {

  PVector pos;

  float ancho;
  float largo;

  float vel = 3;


  Cuadrado(float x, float y, float w, float h) {

    pos = new PVector(x, y);

    ancho = w;
    largo = h;
  }


  void mover() {

    pos.x -= vel;
  }


  void mostrar() {

    fill(0, 200, 100);

    stroke(255);

    rect(
      pos.x,
      pos.y,
      ancho,
      largo
      );
  }
}

class Circulo {

  PVector pos;
  PVector vel;
  PVector acc;

  float tamano = 30;


  Circulo(float x, float y) {

    pos = new PVector(x, y);

    vel = new PVector(0, 0);

    acc = new PVector(0, 0);
  }


  void addFuerza(PVector fuerza) {

    acc.add(fuerza);
  }


  void saltar() {

    vel.y = -8;
  }


  void mover() {

    vel.add(acc);

    pos.add(vel);

    acc.mult(0);
  }


  void mostrar() {

    fill(255, 255, 0);

    noStroke();

    ellipse(
      pos.x,
      pos.y,
      tamano,
      tamano
      );
  }

  boolean colisiona(Cuadrado cuadrado) {

    float cercanoX =
      constrain(
      pos.x,
      cuadrado.pos.x,
      cuadrado.pos.x + cuadrado.ancho
      );

    float cercanoY =
      constrain(
      pos.y,
      cuadrado.pos.y,
      cuadrado.pos.y + cuadrado.largo
      );

    float distanciaX = pos.x - cercanoX;
    float distanciaY = pos.y - cercanoY;

    float distancia =
      sqrt(
      distanciaX * distanciaX +
      distanciaY * distanciaY
      );

    return distancia < tamano/2;
  }
}

class DuplaDeTubos {

  Cuadrado tuboSuperior;
  Cuadrado tuboInferior;

  float espacio;

  float velocidad = 3;


  DuplaDeTubos(
    float x,
    float altoSuperior,
    float altoInferior,
    float gap
    ) {

    espacio = gap;

    tuboSuperior =
      new Cuadrado(
      x,
      0,
      60,
      altoSuperior
      );

    tuboInferior =
      new Cuadrado(
      x,
      height - altoInferior,
      60,
      altoInferior
      );


    tuboSuperior.vel = velocidad;
    tuboInferior.vel = velocidad;
  }

  void mover() {

    tuboSuperior.mover();

    tuboInferior.mover();
  }
  void mostrar() {

    tuboSuperior.mostrar();

    tuboInferior.mostrar();
  }

  boolean colisiona(Circulo pajaro) {

    return
      pajaro.colisiona(tuboSuperior) ||
      pajaro.colisiona(tuboInferior);
  }

  boolean fueraDePantalla() {

    return tuboSuperior.pos.x + tuboSuperior.ancho < 0;
  }
}
