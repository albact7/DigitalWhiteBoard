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
  if (bbCreator.isDone()) { // If bounding box is defined
     opencv.loadImage(video);
     if(colorSeleccionadoCentro && colorSeleccionadoEsquina){ // If center and corner color are selected, ready to run
        board.clickOnRed(video); 
        text("running",width/5, 2*height/3);     
     }else if (!(colorSeleccionadoCentro && colorSeleccionadoEsquina)){
        image(video, 0, 0);
        textSize(100);
        text("selectColor",width/5, 2*height/3);
     }
  }else { // If bounding box is not defined, create it
      background(127,127,127);
      image(video, 0, 0); 
      bbCreator.display();
  }

}

/**

void keyPressed() {
  if (key == 'c') {
     
     println("Calibrating");
     readyToCalibrate=true;
  } 
}
**/

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

void captureEvent(Capture c) {
  c.read();
}
