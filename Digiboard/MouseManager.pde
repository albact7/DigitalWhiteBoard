import arb.soundcipher.*;

class MouseManager {

  private Robot robot;
  private int defaultResolutionX;
  private int defaultResolutionY;
  private PVector startPoint;

  private Dimension screenSize;
  private boolean soundOn;
  private SoundCipher sc;


  MouseManager(int camWidth, int camHeight) {
    this.defaultResolutionX = camWidth;
    this.defaultResolutionY = camHeight;
    screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    this.soundOn = false;
    sc = new SoundCipher();
    try {
      this.robot = new Robot();
    }
    catch (AWTException e) {
      e.printStackTrace();
    }
  }

  void setDefaultResolutionX(int x) {
    this.defaultResolutionX=x;
  }

  void setDefaultResolutionY(int y) {
    this.defaultResolutionY=y;
  }

  int getDefaultResolutionX() {
    return this.defaultResolutionX;
  }

  int getDefaultResolutionY() {
    return this.defaultResolutionY;
  }


  void setDefaultStartPoint(PVector startPoint) {
    this.startPoint = startPoint;
  }

  PVector getStartPoint() {
    return this.startPoint;
  }

  void moveMouse(PVector point) {
    try {

      robot.mouseMove(convertCoordinate((int)point.x, (float) screenSize.getWidth(), (int) startPoint.x, (float) defaultResolutionX), 
        convertCoordinate((int)point.y, (float) screenSize.getHeight(), (int) startPoint.y, (float) defaultResolutionY));
      Thread.sleep(100);
    }
    catch(InterruptedException e) {
      e.printStackTrace();
    }
  }


  void clickMouse() {
    sound();
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
  }

  void sound() {
    if (this.soundOn) {
      sc.instrument(115);
      sc.playNote(70, 100, 0.5);
    }
  }

  void setSoundOn() {
    this.soundOn = true;
  }
  void setSoundOff() {
    this.soundOn = false;
  }

  boolean isSoundOn() {
    return this.soundOn;
  }

  boolean samePlace(int newX, int newY, int[] click) {
    boolean rightX=false;
    boolean rightY=false;

    for (int i =0; i<20; i++) {
      if ((click[0] == newX+i) || (click[0] == newX-i)) {
        rightX=true;
      }
      if ((click[1] == newY+i) || (click[1] == newY-i)) {
        rightY=true;
      }
    }
    return rightX && rightY;
  }

  int convertCoordinate(int a, float screen, int startPoint, float defaultResolution) {
    a= a - int(startPoint);
    int newC=0;
    if (a>=0) {
      newC = (int)(((float)a + (float)a*(abs(defaultResolution - screen)/defaultResolution))) ;
    }
    return newC;
  }
}
