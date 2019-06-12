import java.awt.*;
import java.awt.event.InputEvent;
import java.util.Random; //BOrrar
class Board {

  private int resolutionX;
  private int resolutionY;
  private PVector startPoint;

  private color colorDetectionCenter;
  private color colorDetectionCorner;


  private MouseManager mouseManager;
  private static final int WAIT_FOR_CLICK=2;
  private int click[]=new int [2];
  private int numberOfClick;
  private static final int WAIT_AFTER_CLICK=5 ;
  private int waitUntilNextClick;

  private PVector lastRed;

  Board(MouseManager mouseManager) {
    this.mouseManager = mouseManager; 
    this.numberOfClick=0;
    this.waitUntilNextClick=WAIT_AFTER_CLICK;
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

  private void paint(int newMouseX, int newMouseY) {
    noStroke();
    strokeWeight(10);
    stroke(color(0, 255, 0));
    point(newMouseX, newMouseY);
  }


  void moveOnRed(Capture video) {
    PVector result = whereIsRed(video);
    if (result!=null) mouseManager.moveMouse(result);
  }

  PVector whereIsRed(Capture video) {
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
        if (numberOfClick==WAIT_FOR_CLICK) {
          doTheClick();
          numberOfClick =0;
        }
        return lastRed;
      }
    }
    return null;
  }

  private void doTheClick() {
    if (waitUntilNextClick==WAIT_AFTER_CLICK) {
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

  boolean areAllNear(int pixelValue) {
    return areNearColors(red(pixelValue), red(this.colorDetectionCenter)) && areNearColors(blue(pixelValue), blue(this.colorDetectionCenter)) && 
      areNearColors(green(pixelValue), green(this.colorDetectionCenter))
      || ( areNearColors(red(pixelValue), red(this.colorDetectionCorner)) && areNearColors(blue(pixelValue), blue(this.colorDetectionCorner)) && 
      areNearColors(green(pixelValue), green(this.colorDetectionCorner)));
  }
}
