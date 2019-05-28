import arb.soundcipher.*;
import gab.opencv.*;
import processing.video.*;

boolean TEST_MODE=false;

Capture video;
OpenCV opencv;

BoundingBoxCreator bbCreator;

float inicio_captura_x;
float inicio_captura_y;

int indexInstrumento;
Board board;
boolean colorSeleccionadoCentro;
boolean colorSeleccionadoEsquina;
MouseManager mouseManager;

InterfaceComponent soundTg;
InterfaceComponent bboxBt;
InterfaceComponent colorBt;

PFont font;

PImage backgroundI;
PImage borderI;


Dimension screenSize;
int screenWidth;
int screenHeight;
static final int CAM_WIDTH = 640;
static final int CAM_HEIGHT = 480;

boolean validBB;

void setup() {

  font = createFont("Irregularis.ttf", 32);
  textFont(font);

  fullScreen();
  video = new Capture(this, CAM_WIDTH, CAM_HEIGHT );

  opencv = new OpenCV(this, CAM_WIDTH, CAM_HEIGHT);

  mouseManager = new MouseManager(CAM_WIDTH, CAM_HEIGHT);
  bbCreator = new BoundingBoxCreator(mouseManager);

  if (!TEST_MODE) {
    try {
      video.start();
    }
    catch(RuntimeException e) {
      exit();
    }

    this.inicio_captura_x = width / 2 - 320;
    this.inicio_captura_y = height/2 - 240;

    board = new Board(mouseManager);
    board.setupBoard();

    colorSeleccionadoCentro=false;
    colorSeleccionadoEsquina=false;
    
    this.validBB = true;


    this.soundTg = new ToggleButton(this, true, width*0.8, height*0.5, 200, 100);
    this.bboxBt = new Button(this, "bbox", width*0.8, height*0.2, 200, 200, "data/bbox_up.png", "data/bbox_down.png");
    this.colorBt = new Button(this, "color", width*0.8, height*0.7, 200, 200, "data/color_up.png", "data/color_down.png");

    this.borderI = loadImage("data/border.png");
    this.borderI.resize(788, 0);
    this.backgroundI = loadImage("data/wall.png");
    this.backgroundI.resize(width, 0);
  }
}

void createPoints() { 
  this.screenSize = Toolkit.getDefaultToolkit().getScreenSize();
  this.screenWidth = (int) screenSize.getWidth();
  this.screenHeight = (int) screenSize.getHeight();
}


void draw() {
  if (TEST_MODE) {
    fill(0, 0, 0);
    textSize(100);
    text("Running tests, check console", width/4, height/2);
    delay(1000);
    Test test = new Test();
    test.run();
  } else {
    background(255, 255, 255);

    image(this.backgroundI, 0, 0);
    image(this.borderI, 0, 0);
    buttonEvent();
    buttonHide();
    if (bbCreator.isDone()) { // If bounding box is defined
      opencv.loadImage(video);
      if (colorSeleccionadoCentro && colorSeleccionadoEsquina) { // If center and corner color are selected, ready to run
        image(video, 0, 0);
        board.clickOnRed(video); 
        fill(0, 0, 0);
        textSize(100*height*0.001-50);
        text("You are using Digiboard :)", 100, height - 300); 
        buttonShow();
      } else if (!(colorSeleccionadoCentro && colorSeleccionadoEsquina)) {
        image(video, 0, 0);
        textSize(100*height*0.001-50);
        fill(0, 0, 0);
        if (!colorSeleccionadoCentro) {
          text("select color inside box", 100, height - 300);
        } else {
          text("select color once more", 100, height - 300);
        }
        helpColor();
      }
    } else { // If bounding box is not defined, create it
      fill(0, 0, 0);
      image(video, 0, 0);
      bbCreator.display();
      helpBbox();
    }
  }
}

void helpBbox() {
  int step= 70;
  int start=height - 300;
  fill(0, 0, 0);
  textSize(100*height*0.001-50);
  text("create bounding box", 100, start);
  textSize(60*height*0.001-20);
  text("1. click inside the board up here to fix the left up corner of the box", 130, start+step);
  text("2. move the mouse covering the area you will use as the board", 130, start+step*2);
  text("3. click again to finish the bounding box", 130, start+step*3); 
  if(!this.validBB){
    fill(255, 0, 0);
    textSize(100*height*0.001-50);
    text("Stay inside!", 200, 200);
  }
}

void helpColor() {
  int step= 70;
  int start=height - 300;
  textSize(60*height*0.001-20);
  text("1. place in front your webcam your pointer with the color you want", 130, start+step);
  text("2. click to select the color to recognize as the mouse", 130, start+step*2);
  text("3. you will have to do 2. twice, so try to move your pointer", 130, start+step*3);
  text("to a darker or lighter place", 150, start+step*4);
}

void keyPressed() {
  if (key == 'c') { // Select colors again
    colorSeleccionadoCentro = false;
    colorSeleccionadoEsquina = false;
  } 
  if (key == 'b') {
    bbCreator.setNotCreatedBoundingBox();
  }
  if (key == 's') {
    mouseManager.setSoundOn();
  }
}


void mouseClicked() {
  if (bbCreator.isDone()) { // Afted bounding box is created, select colors
    if (isInsideCam(mouseX, mouseY)) {
      if (!colorSeleccionadoCentro) { // First, center color selected
        color pixel = video.pixels[mouseY*640+mouseX];
        board.setColorDetectionCenter(pixel);
        colorSeleccionadoCentro=true;
      } else if (!colorSeleccionadoEsquina) { // Then, corner color selected
        color pixel = video.pixels[mouseY*640+mouseX];
        board.setColorDetectionCorner(pixel);
        colorSeleccionadoEsquina=true;
      }
    }
  } else {
    this.validBB = bbCreator.onMouseClick(); // Create bounding box
    board.setConstants();
  }
}

boolean isInsideCam(int x, int y) {
  return ((0 <= x) && (x <= 640) && (0 <= y) && (y <= 480) );
}

void buttonHide() {
  this.soundTg.hide();
  this.bboxBt.hide();
  this.colorBt.hide();
}

void buttonShow() {
  this.soundTg.show();
  this.bboxBt.show();
  this.colorBt.show();
}

void buttonEvent() {
  if (this.soundTg.isPressed()) {
    mouseManager.setSoundOn();
  } else {
    mouseManager.setSoundOff();
  }
  if (this.bboxBt.isPressed()) {
    delay(250);
    bbCreator.setNotCreatedBoundingBox();
  }
  if (this.colorBt.isPressed()) {
    delay(250);
    colorSeleccionadoCentro = false;
    colorSeleccionadoEsquina = false;
  }
}

void captureEvent(Capture c) {
  c.read();
}
