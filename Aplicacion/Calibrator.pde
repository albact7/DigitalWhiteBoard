import java.util.ArrayList;
import java.util.List;
class Calibrator{

MouseManager mouseManager;
// Points to draw
CalibPoint pointA; // Up left point
CalibPoint pointB; // Up right point
CalibPoint pointC; // Dpwn left point
CalibPoint pointD; // Down right point
Dimension screenSize;
int screenWidth;
int screenHeight;
List<CalibPoint> pointsList = new ArrayList<CalibPoint>();
boolean[] clickedPoints = new boolean [4];
boolean calibrated;

  Calibrator(MouseManager mouseManager) {
    this.mouseManager = mouseManager;
    this.screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    this.screenWidth = (int) screenSize.getWidth();
    this.screenHeight = (int) screenSize.getHeight();
    createPoints();
  }
  
  void createPoints(){
    
    pointA = new CalibPoint(new PVector(screenWidth/4, screenHeight/4));
    pointB = new CalibPoint(new PVector(screenWidth*3/4, screenHeight/4));
    pointC = new CalibPoint(new PVector(screenWidth/4, screenHeight*3/4));
    pointD = new CalibPoint(new PVector(screenWidth*3/4, screenHeight*3/4));
    
    pointsList.add(pointA);
    pointsList.add(pointB);
    pointsList.add(pointC);
    pointsList.add(pointD);
    
    
  }
  
  void displayCalibrationScreen(){
   
    strokeWeight(40);
    stroke(color(255, 0, 0));
    //line(oldMouseX,oldMouseY,newMouseX,newMouseY);

    for(CalibPoint p : pointsList){
      if(!p.isClicked()) point(p.getCoordinates().x, p.getCoordinates().y); 
    }
    textSize(60);
    text("Click on the four points", 10, 30);
    
    
  }
  
  boolean isCalibrated(){
     return calibrated; 
  }
  
  void onMouseClick(PVector foundRed) {
    for(int i = 0; i<4; i++){
       if(!pointsList.get(i).isClicked()){
         mouseManager.setRefPoints(i, foundRed);
         pointsList.get(i).setClicked(true);
         if(i==pointsList.size()-1) calibrated=true;
        // displayOK();
        println("Calibrated");
         break;
       }
       
    }
  }
  
  void displayOK(){
    textSize(100);
    text("OK",width/5, 2*height/3);
    try{
       Thread.sleep(2000);
    }catch(InterruptedException e){
    e.printStackTrace();
    }
  }
  
}
