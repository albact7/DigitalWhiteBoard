class BoundingBoxCreator {

  boolean createdBoundingBox = false;
  PVector bbStartPoint;
  float bbWidth;
  float bbHeight;
  MouseManager mouseManager;
  PVector resolution;


  BoundingBoxCreator(MouseManager mouseManager) {
    this.createdBoundingBox = false;
    this.bbStartPoint = new PVector(-1, -1);
    this.bbWidth = Float.MIN_VALUE;
    this.bbHeight = Float.MIN_VALUE;
    this.mouseManager = mouseManager;
    this.resolution = new PVector(640, 480);
  }

  void display() {
    if (!createdBoundingBox) {

      if (bbStartPoint.x != -1) {
        fill(255, 0, 0);
        strokeWeight(2);
        stroke(0, 0, 0);
        point(bbStartPoint.x, bbStartPoint.y);

        fill(125, 20, 255, 200);
        float tempWidth = mouseX - bbStartPoint.x;
        float tempHeight = mouseY - bbStartPoint.y;
        float tempx = bbStartPoint.x;
        float tempy = bbStartPoint.y;

        extendBB(tempWidth, tempHeight, tempx, tempy);
      }
    }
  }

  private void extendBB(float tempWidth, float tempHeight, float tempx, float tempy) {

    if (tempWidth < 0 && tempHeight < 0) {
      tempWidth = abs(tempWidth);
      tempx = bbStartPoint.x - mouseX;
      tempy = bbStartPoint.y - mouseY;
      rect(mouseX, mouseY, tempx, tempy);
    } else if (tempHeight < 0) {
      tempHeight = abs(tempHeight);
      tempy = bbStartPoint.y - mouseY;
      if (tempWidth > this.resolution.x-tempx) tempWidth =  this.resolution.x-tempx;
      rect(bbStartPoint.x, mouseY, tempWidth, abs(tempHeight));
    } else if (tempWidth < 0 ) {
      if (tempHeight > this.resolution.y-tempy) tempHeight =  this.resolution.y-tempy;
      rect(mouseX, bbStartPoint.y, abs(tempWidth), tempHeight);
    } else {
      if (tempWidth > this.resolution.x-tempx) tempWidth =  this.resolution.x-tempx;
      if (tempHeight > this.resolution.y-tempy) tempHeight =  this.resolution.y-tempy;

      rect(tempx, tempy, tempWidth, tempHeight);
    }
  }


  void onMouseClick() {
    if (!createdBoundingBox) { 
      if (isInsideCam(mouseX, mouseY)) {
        if (bbStartPoint.x == -1) {
          bbStartPoint = new PVector(mouseX, mouseY);
        } else {
          bbWidth = mouseX - bbStartPoint.x;
          bbHeight = mouseY - bbStartPoint.y;
          if (bbWidth < 0) {
            bbWidth = abs(bbWidth);
            bbStartPoint.x = bbStartPoint.x - bbWidth;
          }
          if (bbHeight < 0) {
            bbHeight = abs(bbHeight);
            bbStartPoint.y = bbStartPoint.y - bbHeight;
          }

          if (bbWidth > this.resolution.x-bbStartPoint.x) bbWidth =  this.resolution.x-bbStartPoint.x;
          if (bbHeight > this.resolution.y-bbStartPoint.y) bbHeight =  this.resolution.y-bbStartPoint.y;

          createdBoundingBox = true;
          setMouseManager();
        }
      }
    }
  }

  boolean isInsideCam(int x, int y) {
    return ((0 <= x) && (x <= this.resolution.x) && (0 <= y) && (y <= this.resolution.y) );
  }

  boolean isDone() {
    return this.createdBoundingBox;
  }

  void setNotCreatedBoundingBox() {
    this.createdBoundingBox = false;
    this.bbStartPoint = new PVector(-1, -1);
    this.bbWidth = Float.MIN_VALUE;
    this.bbHeight = Float.MIN_VALUE;
  }

  void setMouseManager() {
    mouseManager.setDefaultResolutionX(int(bbWidth));
    mouseManager.setDefaultResolutionY(int(bbHeight));
    mouseManager.setDefaultStartPoint(bbStartPoint);
  }
}
