import arb.soundcipher.*;
import gab.opencv.*;
import processing.video.*;


Capture video;
OpenCV opencv;

SeleccionColor scolor;
BoundingBoxCreator bbCreator;

float inicio_captura_x;
float inicio_captura_y;

int indexInstrumento;
Board board;
boolean colorSeleccionadoCentro;
boolean colorSeleccionadoEsquina;
MouseManager mouseManager;

ToggleButton soundTg;
Button bboxBt;
Button colorBt;

PFont font;

PImage backgroundI;
PImage borderI;


void setup() {

  font = createFont("Irregularis.ttf", 32);
  textFont(font);
  
  fullScreen();
  video = new Capture(this, 640 , 480 );
  
  opencv = new OpenCV(this, 640, 480);
 

  println(opencv.width, opencv.height);
  mouseManager = new MouseManager();
  bbCreator = new BoundingBoxCreator(mouseManager);
  scolor= new SeleccionColor(width*0.93, height*0.1,width*0.09);
  
  try{
    video.start();
  }catch(RuntimeException e){
    exit();
  }
  
  this.inicio_captura_x = width / 2 - 320;
  this.inicio_captura_y = height/2 - 240;
  
  board = new Board(mouseManager);
  board.setupBoard();

  colorSeleccionadoCentro=false;
  colorSeleccionadoEsquina=false;

  this.soundTg = new ToggleButton(this, "Sound", "Sound OFF", true, width*0.8,height*0.5, 200,100);
  this.bboxBt = new Button(this, "bbox", true, width*0.8,height*0.2, 200,200, width*0.75, "data/bbox_up.png", "data/bbox_down.png");
  this.colorBt = new Button(this, "color", true, width*0.8,height*0.7, 200,200, width*0.75, "data/color_up.png", "data/color_down.png");
  
  this.borderI = loadImage("data/border.png");
  this.borderI.resize(788,0);
  this.backgroundI = loadImage("data/wall.png");
  this.backgroundI.resize(width,0);
}

Dimension screenSize;
int screenWidth;
int screenHeight;
void createPoints(){
     
 this.screenSize = Toolkit.getDefaultToolkit().getScreenSize();
 this.screenWidth = (int) screenSize.getWidth();
 this.screenHeight = (int) screenSize.getHeight();

    
}



void draw() {
  background(255,255,255);
  
  image(this.backgroundI, 0, 0);
  image(this.borderI, 0, 0);
  buttonEvent();
  buttonHide();
  if (bbCreator.isDone()) { // If bounding box is defined
     opencv.loadImage(video);
     if(colorSeleccionadoCentro && colorSeleccionadoEsquina){ // If center and corner color are selected, ready to run
        image(video, 0, 0);
        board.clickOnRed(video); 
        fill(0, 0, 0);
        textSize(100);
        text("You are using Digiboard :)",100, 750); 
        buttonShow();
     }else if (!(colorSeleccionadoCentro && colorSeleccionadoEsquina)){
        image(video, 0, 0);
        textSize(100);
        fill(0, 0, 0);
        if(!colorSeleccionadoCentro){
          text("select color inside box",100, 750);
        }else{
          text("select color once more",100, 750); 
        }
        helpColor();
        
     }
  }else { // If bounding box is not defined, create it
     // background(255,255,255);
    fill(0, 0, 0);
    helpBbox();
    image(video, 0, 0); 
    bbCreator.display();
  
  }

}

void helpBbox(){
    textSize(100);
    text("create bounding box",100, 750);
    textSize(60);
    text("1. click inside the board up here to fix the left up corner of the box",130, 830);
    text("2. move the mouse covering the area you will use as the board",130, 900);
    text("3. click again to finish the bounding box",130, 970);
}

void helpColor(){
    textSize(60);
    text("1. place in front your webcam your pointer with the color you want",130, 830);
    text("2. click to select the color to recognize as the mouse",130, 900);
    text("3. you will have to do 2. twice, so try to move your pointer",130, 970);
    text("to a darker or lighter place",150, 1040);
}

void keyPressed() {
  if (key == 'c') { // Select colors again
     colorSeleccionadoCentro = false;
     colorSeleccionadoEsquina = false;     
  } 
  if (key == 'b'){
     bbCreator.setNotCreatedBoundingBox(); 
  }
  if (key == 's'){
     mouseManager.setSoundOn();
  }
}


void mouseClicked(){
  if(bbCreator.isDone()){ // Afted bounding box is created, select colors
      if(isInsideCam(mouseX, mouseY)){
      if(!colorSeleccionadoCentro){ // First, center color selected
       color pixel = video.pixels[mouseY*640+mouseX];
       scolor.cambiarColorActualCentro(pixel);
       board.setColorDeteccionCentro(pixel);
       colorSeleccionadoCentro=true;
      
      }else if(!colorSeleccionadoEsquina){ // Then, corner color selected
       color pixel = video.pixels[mouseY*640+mouseX];
       scolor.cambiarColorActualEsquina(pixel);
       board.setColorDeteccionEsquina(pixel);
       colorSeleccionadoEsquina=true;
       
      }
      }
  }else{
    bbCreator.onMouseClick(); // Create bounding box
    board.setConstants();
  }
  
}

boolean isInsideCam(int x, int y){
    return ((0 <= x) && (x <= 640) && (0 <= y) && (y <= 480) );
}

void buttonHide(){
  this.soundTg.hide();
  this.bboxBt.hide();
  this.colorBt.hide();
}

void buttonShow(){
  this.soundTg.show();
  this.bboxBt.show();
  this.colorBt.show();
}

void buttonEvent(){
  if(this.soundTg.getValue()){
    mouseManager.setSoundOn();
  }else{
    mouseManager.setSoundOff();
  }
  if(this.bboxBt.isPressed()){
    delay(250);
    bbCreator.setNotCreatedBoundingBox(); 
  }
  if(this.colorBt.isPressed()){
    delay(250);
    colorSeleccionadoCentro = false;
    colorSeleccionadoEsquina = false;
  }
}


void captureEvent(Capture c) {
  c.read();
}
