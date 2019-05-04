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

void setup() {

  fullScreen();
  video = new Capture(this, 640 , 480 );
  
  opencv = new OpenCV(this, 640, 480);
 

  println(opencv.width, opencv.height);
  mouseManager = new MouseManager();
  bbCreator = new BoundingBoxCreator(mouseManager);
  scolor= new SeleccionColor(width*0.93, height*0.1,width*0.09);
  
  video.start();
  
  this.inicio_captura_x = width / 2 - 320;
  this.inicio_captura_y = height/2 - 240;
  
  board = new Board(mouseManager);
  board.setupBoard();

  colorSeleccionadoCentro=false;
  colorSeleccionadoEsquina=false;

  this.soundTg = new ToggleButton(this, "Sound ON", "Sound OFF", true, width*0.8,height*0.5, 200,100);
  this.bboxBt = new Button(this, "Create bounding box", true, width*0.8,height*0.2, 200,200, width*0.75);
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
  background(0,0,0);
  buttonEvent();
  buttonHide();
  if (bbCreator.isDone()) { // If bounding box is defined
     opencv.loadImage(video);
     if(colorSeleccionadoCentro && colorSeleccionadoEsquina){ // If center and corner color are selected, ready to run
        image(video, 0, 0);
        board.clickOnRed(video); 
        fill(255, 255, 255);
        text("running",width/5, 2*height/3); 
        buttonShow();
     }else if (!(colorSeleccionadoCentro && colorSeleccionadoEsquina)){
        image(video, 0, 0);
        textSize(100);
        fill(255, 255, 255);
        if(!colorSeleccionadoCentro){
          text("select color inside box",width/5, 2*height/3);
        }else{
          text("select color once more",width/5, 2*height/3); 
        }
     }
  }else { // If bounding box is not defined, create it
     // background(255,255,255);
    fill(255, 255, 255);
    textSize(100);
    text("create bounding box",width/5, 2*height/3);
    image(video, 0, 0); 
    bbCreator.display();
  
  }

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


void mouseClicked()
{
  if(bbCreator.isDone()){ // Afted bounding box is created, select colors
    
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
  }else{
    bbCreator.onMouseClick(); // Create bounding box
  }
  
}

void buttonHide(){
  this.soundTg.hide();
  this.bboxBt.hide();
}

void buttonShow(){
  this.soundTg.show();
  this.bboxBt.show();
}

void buttonEvent(){
  if(this.soundTg.getValue()){
    mouseManager.setSoundOn();
  }else{
    mouseManager.setSoundOff();
  }
  if(this.bboxBt.isPressed()){
    bbCreator.setNotCreatedBoundingBox(); 
  }
}


void captureEvent(Capture c) {
  c.read();
}
