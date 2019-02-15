class MouseManager{

Robot robot;
public int defaultResolutionX = 640;
public int defaultResolutionY = 480;
public PVector startPoint;

 MouseManager() {
   try{
     robot = new Robot();
   }catch (AWTException e){
    e.printStackTrace();
   }
 }
  
 void setDefaultResolutionX(int x){
   println(x);
    this.defaultResolutionX=x;
 }
  
 void setDefaultResolutionY(int y){
   println(y);
    this.defaultResolutionY=y;
 }
 
 void setDefaultStartPoint(PVector startPoint){
     this.startPoint = startPoint;
 }
 
 void moveMouse(int x, int y){
 
 try{
   robot.mouseMove(convertCoordinateX(x), convertCoordinateY(y));
   Thread.sleep(100);
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
    int newX = (x + x*(abs(defaultResolutionX - screenWidth)/defaultResolutionX)) + defaultResolutionX/6;
   return newX;
 }
  
 int convertCoordinateY(int y){
   Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
   int screenHeight = (int) screenSize.getHeight();
 //  int newY = (y + y*(abs(defaultResolutionY - screenHeight)/defaultResolutionY)) - int(startPoint.y) - defaultResolutionY*(1/y);
   y= y - int(startPoint.y);
   int newY = (y + y*(abs(defaultResolutionY - screenHeight)/defaultResolutionY)) + defaultResolutionY/5;
   return newY;
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
}
