import java.util.Collections;

// Variables
int filas = 40;
int columnas= 40;
int cuadrado= 20; // Tamaño que tiene la Manzana y la Serpiente.
int contador=0; // Cuenta las Manzanas que se ha comido la Serpiente.

/* ArrayList donde se guarda las posiciones de la Serpiente
para que la serpiente se haga más grande.*/
ArrayList <Integer> posX= new ArrayList<Integer>();
ArrayList <Integer> posY= new ArrayList<Integer>();

// ArrayList donde se guarda el record de Manzanas comidas.
ArrayList <Integer> top= new ArrayList<Integer>();

int direccion= 1; // Cada vez que se ejecute el juego la Serpiente se desplazara hacia abajo (DOWN).
int [] dx= {0, 0, -1, 1}; // La serpiente se mueve de Izquierda a Derecha.
int [] dy= {-1, 1, 0, 0}; // La serpiente se mueve de Arriba a Abajo.

// Posiciones de la Manzana.
int ManzanaX;
int ManzanaY;

boolean game_over= false; // Indica si se ha perdido la partida. (Por salir del limite del mapa o chocar con la cola de la Serpiente).
boolean niveles= false;

void setup(){
  size(800, 800); // Tamaño del tablero.
  posX.add(10); // Posición inicial que tiene la Serpiente al inicio de la partida.
  posY.add(10);
  frameRate(10);
  // Define los ejes X e Y dentro del tablero | X2 Y7  -  X37 Y7 
  ManzanaX=(int)((Math.random()*(37-2))+2);
  ManzanaY =(int)((Math.random()*(37-7))+7);
}

void draw(){
  textSize(25); // Tamaño del texto
  PImage fondo = loadImage("Images/map.jpeg"); // Carga la imagen.
  image(fondo, 0, 0); // Establece la imagen como fondo.
  
  // Puntuación
  String puntuacion= "Score: ";
  PImage manzana = loadImage("Images/apple.png");
  fill(250); // Color del Texto.
  text(puntuacion + contador, 40, 55);
  
  // Segun el numero de manzanas comidas, al tener el numero más longitud (ocupa más espacio) y por eso muevo la imagen más a la derecha.
  if(contador < 10){
    image(manzana, 130, 30, 30, 30);
  }else if(contador >=10 && contador <=99){
    image(manzana, 140, 30, 30, 30);
  }else if(contador >= 100 && contador <= 999){
    image(manzana, 150, 30, 30, 30);
  }else if(contador >= 1000){
      image(manzana, 162, 30, 30, 30);
  }else{
    contador = 0;
  }
  
  // Record
  String tops= "Top: ";
  fill(250);
  top.add(0); // Añade un elemento en el ArrayList para que no este vacia.
  int max= Collections.max(top); // Devuelve el mayor número del ArrayList.
  text(tops + max, 300, 55);
  PImage cup= loadImage("Images/cup.png");
  // Cambia la posición de la imagen segun el (max).
  if(max < 10){ 
    image(cup, 365, 20, 50, 50);
  }else if(max >= 10 && max <=99){
    image(cup, 380, 20, 50, 50);
  }else if(max >=100 && max <=999){
    image(cup, 390, 20, 50, 50);
  }else if(max >= 1000){
    image(cup, 400, 20, 50, 50);
  }else{
    max=0;
  }
  // LLamada a los Métodos.
  mover();
  comerManzana();
  limiteTablero();
  detectarSerpiente();
  drawManzana();
  drawSerpiente();
  
  // Si el jugador pierde, se le lleva a la pantalla principal.
  if(game_over == true){ 
    pantalla_principal();
  }
  if(niveles== true){
    pantalla_niveles();
  }
}

void comerManzana(){
  if((posX.get(0)== ManzanaX) && (posY.get(0)==ManzanaY)){
    ManzanaX=(int)((Math.random()*(37-2))+2);
    ManzanaY =(int)((Math.random()*(37-7))+7);
    posX.add(posX.get(posX.size()-1));
    posY.add(posY.get(posY.size()-1));
    contador++;
  }
}

// Pinta la Manzana.
void drawManzana(){
  PImage Manzana = loadImage("Images/apple.png");
  image(Manzana, ManzanaX*cuadrado, ManzanaY * cuadrado, cuadrado, cuadrado);
}

// Pinta la Serpiente.
void drawSerpiente(){
  PImage Serpiente = loadImage("Images/bodySnake.png");
  fill(40, 50, 230); // Color de la Serpiente.
  for(int i=0; i < posX.size(); i++){
    image(Serpiente, posX.get(i)*cuadrado, posY.get(i)*cuadrado, cuadrado, cuadrado);
  }
}

void mover(){
  posX.add(0, posX.get(0)+dx[direccion]);
  posY.add(0, posY.get(0)+dy[direccion]);
  posX.remove(posX.size()-1);
  posY.remove(posY.size()-1);
}

// Si la cabeza de la Serpiente toca el limite del tablero el juego finaliza.
void limiteTablero(){
  if((posX.get(0) < 2) || (posX.get(0) > columnas -3) || (posY.get(0) < 7) || (posY.get(0) > filas -3)){
    game_over= true;
  }
}

// Si la Serpiente se choca contra ella misma el juego finaliza.
void detectarSerpiente(){
  for(int i=2; i < posX.size(); i++){
    for(int j=2; j < posY.size(); j++){
      if(posX.get(0) == posX.get(i) && (posY.get(0)== posY.get(i))){
          game_over= true;
      }
    }
  }
}

// Se ejecuta cada vez que el jugador pierde.
void resetear(){
  game_over= false;
  posX.clear(); // Borra el contenido de los 2 ArrayList.
  posY.clear();
  posX.add(10); // Devuelve la Serpiente a la posicion inicial.
  posY.add(10);
  // Pone la Manzana es una posicion aleatoria dentro del tablero.
  ManzanaX=(int)((Math.random()*(37-2))+2);
  ManzanaY =(int)((Math.random()*(37-7))+7);
  top.add(contador); // Añade las Manzanas comidas en la partida, en el ArrayList.
  contador= 0; // Resetea el contador.
}

void pantalla_principal(){
  PImage fondo = loadImage("Images/menu.jpeg");
  image(fondo, 0, 0);
  text("Press Enter to play.", 150, height/1.30);
  text("Press Space to change level.", 150, height/1.22);
  ManzanaX= -1; // Borra la Manzana de la pantalla.
  ManzanaY= -1;
}


// Cambia la dificultad del juego segun el numero que ha puesto el usuario.
void pantalla_niveles(){
  PImage fondo = loadImage("Images/menu.jpeg");
  image(fondo, 0, 0);
    textSize(25);
    text("1. Easy",300, height/1.3);
    text("2. Normal", 300, height/1.22);
    text("3. Hard", 300, height/1.14);
    if(keyCode== '1'){
      frameRate(10);
      niveles= false;
    }else if(keyCode== '2'){
      frameRate(20);
      niveles= false;
    }else if(keyCode== '3'){
      frameRate(30);
      niveles= false;
    }
}


// Segun la tecla pulsada por el usuario la Serrpiente se mueve a la derecha o izquierda y arriba o abajo.
void keyPressed(){  
  if(key == 'w' || keyCode== UP) direccion= 0;
  else if(key == 's' || keyCode== DOWN) direccion= 1;
  else if(key == 'a' || keyCode== LEFT) direccion= 2;
  else if(key == 'd' || keyCode== RIGHT) direccion= 3;

  else if(keyCode == ' '){
    niveles= true;
  }
  else if(keyCode == ENTER || keyCode== RETURN){
      resetear();
  }
}
