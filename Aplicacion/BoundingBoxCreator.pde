class BoundingBoxCreator {
  
  boolean createdBoundingBox = false;

  PVector bbStartPoint;
  float bbWidth;
  float bbHeight;
  MouseManager mouseManager;
  

  BoundingBoxCreator(MouseManager mouseManager) {
    this.createdBoundingBox = false;
    this.bbStartPoint = new PVector(-1, -1);
    this.bbWidth = Float.MIN_VALUE;
    this.bbHeight = Float.MIN_VALUE;
    this.mouseManager = mouseManager;
  }
  
 void display() {
    if (!createdBoundingBox) {
      if (bbStartPoint.x != -1) {
        fill(255, 0, 0);
        strokeWeight(2);
        point(bbStartPoint.x, bbStartPoint.y);
        
        fill(125, 20, 255, 200);
        float tempWidth = mouseX - bbStartPoint.x;
        float tempHeight = mouseY - bbStartPoint.y;
        float tempx = bbStartPoint.x;
        float tempy = bbStartPoint.y;
        if (tempWidth < 0 && tempHeight < 0) {
           tempWidth = abs(tempWidth);
           tempx = bbStartPoint.x - mouseX;
           tempy = bbStartPoint.y - mouseY;
           rect(mouseX, mouseY, tempx, tempy);
        } else if (tempHeight < 0) {
           tempHeight = abs(tempHeight);
           tempy = bbStartPoint.y - mouseY;
           rect(bbStartPoint.x, mouseY, tempWidth, abs(tempHeight));
        } else if (tempWidth < 0 ) {
          rect(mouseX, bbStartPoint.y, abs(tempWidth), tempHeight);
        } else {
          rect(tempx, tempy, tempWidth, tempHeight);
        }
      }
     
    }
  }

  void onMouseClick() {
    if (!createdBoundingBox)
    { 
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
   
        createdBoundingBox = true;
        setMouseManager();
      }
    }
  }
  
  boolean isDone() {
    return this.createdBoundingBox;
  }
  
  void setMouseManager(){
    mouseManager.setDefaultResolutionX(int(bbWidth));
    mouseManager.setDefaultResolutionY(int(bbHeight));
    mouseManager.setDefaultStartPoint(bbStartPoint);
    println("Start Point "+bbStartPoint.x);
    println(bbStartPoint.y);
  }
  
    
  
}
