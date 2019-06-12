import processing.video.*;

private boolean TEST_MODE=false; // Change this variable to "true" to run in test mode

private Capture video;

private BoundingBoxCreator bbCreator;

private Board board;
private boolean selectedColorCenter;
private boolean selectedColorCorner;
private MouseManager mouseManager;

private InterfaceComponent soundTg;
private InterfaceComponent bboxBt;
private InterfaceComponent colorBt;

private PFont font;

private PImage backgroundI;
private PImage borderI;

private static final int CAM_WIDTH = 640;
private static final int CAM_HEIGHT = 480;

private boolean validBB;

void setup() {

  font = createFont("Irregularis.ttf", 32);
  textFont(font);

  fullScreen();
  video = new Capture(this, CAM_WIDTH, CAM_HEIGHT );

  mouseManager = new MouseManager(CAM_WIDTH, CAM_HEIGHT);
  bbCreator = new BoundingBoxCreator(mouseManager);
  video.start();
  if (!TEST_MODE) {
    try {
    }
    catch(RuntimeException e) {
      exit();
    }

    board = new Board(mouseManager);

    selectedColorCenter=false;
    selectedColorCorner=false;

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


void draw() {
  if (TEST_MODE) { // Test mode
    test_MODE();
  } else { // Run app
    runAppSetup();
    if (bbCreator.isDone()) { // If bounding box is defined
      if (selectedColorCenter && selectedColorCorner) { // If center and corner color are selected, ready to run
        runDigiboard_MODE();
      } else if (!(selectedColorCenter && selectedColorCorner)) { // Select color pointer
        selectColor_MODE();
      }
    } else { // If bounding box is not defined, create it
      createBB_MODE();
    }
  }
}

private void test_MODE() {
  fill(0, 0, 0);
  textSize(100);
  text("Running tests, check console", width/4, height/2);
  Test test = new Test();
  test.run();
}

private void runAppSetup() {
  background(255, 255, 255);
  image(this.backgroundI, 0, 0);
  image(this.borderI, 0, 0);
  buttonEvent();
  buttonHide();
}

private void createBB_MODE() {
  fill(0, 0, 0);
  image(video, 0, 0);
  bbCreator.display();
  helpBbox();
}

private void runDigiboard_MODE() {
  image(video, 0, 0);
  board.moveOnRed(video); 
  fill(0, 0, 0);
  textSize(100*height*0.001-50);
  text("You are using Digiboard :)", 100, height - 300); 
  buttonShow();
}

private void selectColor_MODE() {
  image(video, 0, 0);
  textSize(100*height*0.001-50);
  fill(0, 0, 0);
  if (!selectedColorCenter) {
    text("select color inside box", 100, height - 300);
  } else {
    text("select color once more", 100, height - 300);
  }
  helpColor();
}

private void helpBbox() {
  int step= 70;
  int start=height - 300;
  fill(0, 0, 0);
  textSize(100*height*0.001-50);
  text("create bounding box", 100, start);
  textSize(60*height*0.001-20);
  text("1. click inside the board up here to fix the left up corner of the box", 130, start+step);
  text("2. move the mouse covering the area you will use as the board", 130, start+step*2);
  text("3. click again to finish the bounding box", 130, start+step*3); 
  if (!this.validBB) {
    fill(255, 0, 0);
    textSize(100*height*0.001-50);
    text("Stay inside!", 200, 200);
  }
}

private void helpColor() {
  int step= 70;
  int start=height - 300;
  textSize(60*height*0.001-20);
  text("1. place in front your webcam your pointer with the color you want", 130, start+step);
  text("2. click to select the color to recognize as the mouse", 130, start+step*2);
  text("3. you will have to do 2. twice, so try to move your pointer", 130, start+step*3);
  text("to a darker or lighter place", 150, start+step*4);
  if (!this.validBB) {
    fill(255, 0, 0);
    textSize(100*height*0.001-50);
    text("Stay inside!", 200, 200);
  }
}

void keyPressed() {
  if (key == 'c') { // Select colors again
    selectedColorCenter = false;
    selectedColorCorner = false;
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
    if (!selectedColorCenter) { // First, center color selected
      if (isInsideCam(mouseX, mouseY)) {
        color pixel = video.pixels[mouseY*640+mouseX];
        board.setColorDetectionCenter(pixel);
        selectedColorCenter=true;
        this.validBB = true;
      } else {
        println("out");
        this.validBB = false;
      }
    } else if (!selectedColorCorner) { // Then, corner color selected
      if (isInsideCam(mouseX, mouseY)) {
        color pixel = video.pixels[mouseY*640+mouseX];
        board.setColorDetectionCorner(pixel);
        selectedColorCorner=true;
        this.validBB = true;
      } else {
        this.validBB = false;
      }
    }
  } else {

    this.validBB = bbCreator.onMouseClick(); // Create bounding box
    board.setConstants();
  }
}


private boolean isInsideCam(int x, int y) {
  return ((0 <= x) && (x <= 640) && (0 <= y) && (y <= 480) );
}

private void buttonHide() {
  this.soundTg.hide();
  this.bboxBt.hide();
  this.colorBt.hide();
}

private void buttonShow() {
  this.soundTg.show();
  this.bboxBt.show();
  this.colorBt.show();
}

private void buttonEvent() {
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
    selectedColorCenter = false;
    selectedColorCorner = false;
  }
}
void captureEvent(Capture c) {
  c.read();
}
