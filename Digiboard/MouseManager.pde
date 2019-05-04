import arb.soundcipher.*;



class MouseManager{

Robot robot;
public int defaultResolutionX = 640;
public int defaultResolutionY = 480;
public PVector startPoint;

Dimension screenSize;

static final int waitForClick=2;
int click[]=new int [2];

boolean soundOn;
SoundCipher sc;


 MouseManager() {
   screenSize = Toolkit.getDefaultToolkit().getScreenSize();
   this.soundOn = false;
   sc = new SoundCipher();
   try{
     this.robot = new Robot();
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
 
 int getDefaultResolutionX(){
    return this.defaultResolutionX;
 }
  
 int getDefaultResolutionY(){
    return this.defaultResolutionY;
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
    sound();
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.mouseRelease(InputEvent.BUTTON1_MASK); 
 }
 
 void sound(){
   if(this.soundOn){
     sc.instrument(115);
     sc.playNote(70, 100, 0.5);
   }
 }
 
 void setSoundOn(){
   this.soundOn = true;
 }
 void setSoundOff(){
   this.soundOn = false;
 }
 
 boolean isSoundOn(){
   return this.soundOn; 
 }
 
 boolean samePlace(int newX, int newY, int[] click){
     boolean rightX=false;
     boolean rightY=false;
     
     for(int i =0; i<20; i++){
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
   int screenWidth = (int) screenSize.getWidth();
   x= x - int(startPoint.x);
   int newX=0;
   if(x>=0){
     float drF = (float) defaultResolutionX;
     float scF = (float) screenWidth;
     
    newX = (int)(((float)x + (float)x*(abs(drF - scF)/drF))) ;
   }
   return newX;
 }
  
 int convertCoordinateY(int y){
   int screenHeight = (int) screenSize.getHeight();
   y= y - int(startPoint.y);
   int newY=0;
   if(y>=0){
     float drF = (float) defaultResolutionY;
     float scF = (float) screenHeight;
   newY = (int) (((float)y + (float) y*(abs(drF - scF)/drF)));
   }
   return newY;
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
}
