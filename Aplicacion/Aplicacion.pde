import arb.soundcipher.*;
import gab.opencv.*;
import processing.video.*;


Capture video;
OpenCV opencv;

SeleccionColor scolor;
BoundingBoxCreator bbCreator;
SoundCipher sc;

float[] instrumentos;
PImage[] fotos;
PImage flechaUp, flechaDown;


float yLoc = 0.0;
float pitch = 59;

float inicio_captura_x;
float inicio_captura_y;

int indexInstrumento;
Board board;
boolean colorSeleccionadoCentro;
boolean colorSeleccionadoEsquina;
MouseManager mouseManager;

void setup() {



  fullScreen();
  video = new Capture(this, 640 , 480 );
  
  opencv = new OpenCV(this, 640, 480);
 

  println(opencv.width, opencv.height);
  mouseManager = new MouseManager();
  bbCreator = new BoundingBoxCreator(mouseManager);
  scolor= new SeleccionColor(width*0.93, height*0.1,width*0.09);
  
  video.start();
  println("1");

  
  this.inicio_captura_x = width / 2 - 320;
  this.inicio_captura_y = height/2 - 240;
  
  board = new Board(mouseManager);
  board.setupBoard();

  colorSeleccionadoCentro=false;
  colorSeleccionadoEsquina=false;
}



void draw() {

  if (bbCreator.isDone()) {
  // opencv.loadImage(video);
   if(colorSeleccionadoCentro && colorSeleccionadoEsquina){
      board.compruebaPie(video); 
   }else{
      image(video, 0, 0);
   }
  }else {
      background(127,127,127);
      image(video, 0, 0); 
      bbCreator.display();
    }

}



void keyPressed() {
  if (keyCode == DOWN) {
    indexInstrumento = indexInstrumento == 0 ? instrumentos.length - 1 : --indexInstrumento;
  } else if (keyCode == UP){
    indexInstrumento = (indexInstrumento == instrumentos.length - 1) ? 0 : ++indexInstrumento;    
  }
  
  if (keyCode == UP || keyCode == DOWN) {
    sc.instrument(instrumentos[indexInstrumento]); 
    println(instrumentos[indexInstrumento]);
  }
}

void mouseClicked()
{
  if(bbCreator.isDone()){
    if(!colorSeleccionadoCentro){
     color pixel = video.pixels[mouseY*640+mouseX];
     scolor.cambiarColorActualCentro(pixel);
     board.setColorDeteccionCentro(pixel);
     colorSeleccionadoCentro=true;
    
    }else if(!colorSeleccionadoEsquina){
      color pixel = video.pixels[mouseY*640+mouseX];
     scolor.cambiarColorActualEsquina(pixel);
     board.setColorDeteccionEsquina(pixel);
     colorSeleccionadoEsquina=true;
     
    }
  }else{
    bbCreator.onMouseClick();
  }
}

void captureEvent(Capture c) {
  c.read();
}
