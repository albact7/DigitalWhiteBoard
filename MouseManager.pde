class MouseManager{

Robot robot;
static final int defaultResolutionX = 640;
static final int defaultResolutionY = 480;

 MouseManager() {
   try{
     robot = new Robot();
   }catch (AWTException e){
    e.printStackTrace();
   }
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
     
     for(int i =0; i<30; i++){
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
   int newX = x - x*((defaultResolutionX - screenWidth)/defaultResolutionX);
   return newX;
 }
  
 int convertCoordinateY(int y){
   Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
   int screenHeight = (int) screenSize.getHeight();
   int newY = y - y*((defaultResolutionY - screenHeight)/defaultResolutionY);
   return newY;
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
}
