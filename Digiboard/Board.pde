import java.awt.*;
import java.awt.event.InputEvent;
import java.util.Random;
class Board {

  int resolutionX = 640;
  int resolutionY = 480;
  PVector startPoint;


  float oldMouseX, oldMouseY;

  color fondo=color(255, 255, 128);
  color colorDetectionCenter;
  color colorDetectionCorner;
  color paleta[] = {
    color(0), 
    color(255), 
    color(255, 0, 0), 
    color(0, 255, 0), 
    color(0, 0, 255)
  };

  int colorActual=3;    
  int strokeW=10;

  int ell1=1;
  int selectedPoints[][];
  color selectedColors[];
  int point=0;
  int resX = 640;
  int resY = 480;

  MouseManager mouseManager;
  static final int waitForClick=2;
  int click[]=new int [2];
  int numberOfClick=0;
  static final int waitAfterClick=5 ;
  int waitUntilNextClick=waitAfterClick;

  PVector lastRed;

  Board(MouseManager mouseManager) {
    this.mouseManager = mouseManager; 
    setConstants();
  }

  MouseManager getMouseManager() {
    return mouseManager;
  }

  void setConstants() {
    this.resolutionX = this.mouseManager.getDefaultResolutionX();
    this.resolutionY = this.mouseManager.getDefaultResolutionY();
    this.startPoint = this.mouseManager.getStartPoint();
  }

  boolean isInsideBB(int x, int y) {
    return (
      (this.startPoint.x <= x) && (x <= (this.startPoint.x + this.resolutionX))
      &&
      (this.startPoint.y <= y) && (y <= (this.startPoint.y + this.resolutionY))
      );
  }

  void setupBoard() {  
    this.oldMouseX=0;
    this.oldMouseY=0;
  }

  void paint(int newMouseX, int newMouseY) {
    noStroke();
    strokeWeight(strokeW);
    stroke(paleta[colorActual]);

    point(newMouseX, newMouseY);

    oldMouseX=newMouseX;
    oldMouseY=newMouseY;
  }


  PVector clickOnRed(Capture video) {
    mouseManager.moveMouse(whereIsRed(video));
    return null;
  }

  PVector whereIsRed(Capture video) {
    selectedPoints = new int[640*2][3];
    selectedColors = new int[640*2];
    int nearest[] = new int [2];
    float smallestDif=1000;
    boolean painted = false;
    for (int x = 0; x < 640; x++) {
      for (int y = 0; y < 480; y++) {
        int numberPix=640*y + x;
        color pixelValue = video.pixels[numberPix];
        // Determine the color of the pixel
        if (areAllNear(pixelValue)) {
          if (calculateDifference(pixelValue)<smallestDif) {
            painted=true;
            smallestDif = calculateDifference(pixelValue);
            nearest[0]=x;
            nearest[1]=y;
          }
          point++;
        }
      }
    }
    if (isInsideBB(nearest[0], nearest[1])) {
      if (painted) {
        if ( mouseManager.samePlace(nearest[0], nearest[1], click)) {
          numberOfClick++;
          paint(nearest[0], nearest[1]);
          lastRed = new PVector(getCoordinateClose(click[0], nearest[0]), getCoordinateClose(click[1], nearest[1]));
        } else {
          numberOfClick=0;
          click[0]=nearest[0];
          click[1]=nearest[1];
          paint(nearest[0], nearest[1]);
          lastRed = new PVector(nearest[0], nearest[1]);
        }
        if (numberOfClick==waitForClick) {
          doTheClick();
          numberOfClick =0;
        }
        return lastRed;
      }
    }
    return null;
  }

  private void doTheClick() {
    if (waitUntilNextClick==waitAfterClick) {
      mouseManager.clickMouse();
      waitUntilNextClick=0;
    }
    waitUntilNextClick++;
  }

  private int getCoordinateClose(int coord1, int coord2) {
    return coord1 + (coord1-coord2)/2;
  }

  float calculateDifference(color pixelValue) {
    float difRed =max(abs(red(this.colorDetectionCenter)-red(pixelValue)), abs(red(this.colorDetectionCorner)-red(pixelValue)));
    float difGreen =max(abs(green(this.colorDetectionCenter)-green(pixelValue)), abs(green(this.colorDetectionCorner)-green(pixelValue)));
    float difBlue =max(abs(blue(this.colorDetectionCenter)-blue(pixelValue)), abs(blue(this.colorDetectionCorner)-blue(pixelValue)));
    return difRed+difGreen+difBlue;
  }

  void setColorDetectionCenter(color newColor) {
    this.colorDetectionCenter = newColor;
  }
  void setColorDetectionCorner(color newColor) {
    this.colorDetectionCorner = newColor;
  }

  boolean areNearColors(float color1, float color2) {
    return (color1<color2 + 4 && color1 > color2 - 4);
  }

  private boolean areAllNear(int pixelValue) {
    return areNearColors(red(pixelValue), red(this.colorDetectionCenter)) && areNearColors(blue(pixelValue), blue(this.colorDetectionCenter)) && 
      areNearColors(green(pixelValue), green(this.colorDetectionCenter))
      || ( areNearColors(red(pixelValue), red(this.colorDetectionCorner)) && areNearColors(blue(pixelValue), blue(this.colorDetectionCorner)) && 
      areNearColors(green(pixelValue), green(this.colorDetectionCorner)));
  }
}
