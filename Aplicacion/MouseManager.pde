class MouseManager{

Robot robot;
public int defaultResolutionX = 640;
public int defaultResolutionY = 480;
public PVector startPoint;
// Points references
PVector pointA; // Up left point
PVector pointB; // Up right point
PVector pointC; // Dpwn left point
PVector pointD; // Down right point
List<PVector> refPoints;

 MouseManager() {
   refPoints = new ArrayList<PVector>();
   for(int i = 0; i<4; i++){
       refPoints.add(new PVector(0,0));
   }
   try{
     robot = new Robot();
   }catch (AWTException e){
    e.printStackTrace();
   }
 }
 
 void setRefPoints(int index, PVector coord){
     refPoints.set(index, coord);
 }
  
 void setDefaultResolutionX(int x){
   println(x);
    this.defaultResolutionX=x;
 }
  
 void setDefaultResolutionY(int y){
   println(y);
    this.defaultResolutionY=y;
 }
 
PVector getCamResolution(){
   return new PVector(defaultResolutionX, defaultResolutionY);
}
 
 void setDefaultStartPoint(PVector startPoint){
     this.startPoint = startPoint;
 }
 
 PVector getStartPoint(){
     return this.startPoint; 
 }
 
 void moveMouse(PVector point){
 
 try{
   if(point != null){
     robot.mouseMove(convertCoordinateX((int)point.x), convertCoordinateY((int)point.y));
     Thread.sleep(100);
   }
  }catch(InterruptedException e){
  e.printStackTrace();
  }
 }
 
 void clickMouse(){
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.mouseRelease(InputEvent.BUTTON1_MASK); 
 }
 
 boolean samePlace(int newX, int newY, int[] click){
     boolean rightX=false;
     boolean rightY=false;
     
     for(int i =0; i<40; i++){
        if((click[0] == newX+i) || (click[0] == newX-i)){
          rightX=true;
        }
        if((click[1] == newY+i) || (click[1] == newY-i)){
          rightY=true;
        }
     }
     return rightX && rightY;
 }
  
 int convertCoordinateX(int x){
   Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
   int screenWidth = (int) screenSize.getWidth();
  // int newX = (x + x*(abs(defaultResolutionX - screenWidth)/defaultResolutionX)) + int(startPoint.x) ;
   x= x - int(startPoint.x);
   int newX=0;
   if(x>=0){
    newX = (x + x*(abs(defaultResolutionX - screenWidth)/defaultResolutionX)) + defaultResolutionX/6;
   }
   return newX;
 }
  
 int convertCoordinateY(int y){
   Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
   int screenHeight = (int) screenSize.getHeight();
 //  int newY = (y + y*(abs(defaultResolutionY - screenHeight)/defaultResolutionY)) - int(startPoint.y) - defaultResolutionY*(1/y);
   y= y - int(startPoint.y);
   int newY=0;
   if(y>=0){
   newY = (y + y*(abs(defaultResolutionY - screenHeight)/defaultResolutionY)) + defaultResolutionY/5;
   }
   return newY;
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
}
