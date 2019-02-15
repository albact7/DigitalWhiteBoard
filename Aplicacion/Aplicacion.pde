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
Calibrator calibrator;
boolean readyToCalibrate;

void setup() {



  fullScreen();
  video = new Capture(this, 640 , 480 );
  
  opencv = new OpenCV(this, 640, 480);
 

  println(opencv.width, opencv.height);
  mouseManager = new MouseManager();
  bbCreator = new BoundingBoxCreator(mouseManager);
  scolor= new SeleccionColor(width*0.93, height*0.1,width*0.09);
  calibrator = new Calibrator(mouseManager);
  
  video.start();

  
  this.inicio_captura_x = width / 2 - 320;
  this.inicio_captura_y = height/2 - 240;
  
  board = new Board(mouseManager);
  board.setupBoard();

  colorSeleccionadoCentro=false;
  colorSeleccionadoEsquina=false;
}



void draw() {
  background(255,255,255);
  if (bbCreator.isDone()) {
  // opencv.loadImage(video);
   if(colorSeleccionadoCentro && colorSeleccionadoEsquina && calibrator.isCalibrated()){
     image(video, 0, 0);
      //board.clickOnRed(video); 
   }else if (!(colorSeleccionadoCentro && colorSeleccionadoEsquina)){
      image(video, 0, 0);
      textSize(100);
      text("selecciona color",width/5, 2*height/3);
   }else if(!calibrator.isCalibrated()){
     image(video, 0, 0);
     if(readyToCalibrate){
       calibrator.displayCalibrationScreen();
       board.whereIsRed(video);  
     }else{
       text("press c to calibrate",width/5, 2*height/3);
     }
   }
  }else {
      background(127,127,127);
      image(video, 0, 0); 
      bbCreator.display();
  }
  
}



void keyPressed() {
  if (key == 'c') {
     
     println("Calibrating");
     readyToCalibrate=true;
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
  if(!calibrator.isCalibrated()&&readyToCalibrate){
       calibrator.onMouseClick(board.getLastRed());
  }
  
}

void captureEvent(Capture c) {
  c.read();
}
