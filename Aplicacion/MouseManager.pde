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
List<CalibPoint> realPoints;
Dimension screenSize;
int average_error_x;
int average_error_y;

static final int waitForClick=2;
int click[]=new int [2];
int numberOfClick=0;
static final int waitAfterClick=5 ;
int waitUntilNextClick=waitAfterClick;

 MouseManager() {
   this.refPoints = new ArrayList<PVector>();
   this.average_error_x = 0;
   screenSize = Toolkit.getDefaultToolkit().getScreenSize();

   for(int i = 0; i<4; i++){
       refPoints.add(new PVector(0,0));
   }
   try{
     this.robot = new Robot();
   }catch (AWTException e){
    e.printStackTrace();
   }
 }
 
 void setRefPoints(int index, PVector coord){
     refPoints.set(index, coord);
 }
 
 void setRealPoints(List<CalibPoint> list){
     realPoints = list;
 }
 
 void calculateError(){
    double sum_error_x = 0.0;
    for(int i = 0; i < refPoints.size(); i++){
      sum_error_x =+ (convertCoordinateX((int)refPoints.get(i).x) - realPoints.get(i).getCoordinates().x);
    }
    this.average_error_x =  (int) (sum_error_x / refPoints.size());
    println("average error x", this.average_error_x);
    
    double sum_error_y = 0.0;
    for(int i = 0; i < refPoints.size(); i++){
      sum_error_y =+ (refPoints.get(i).y - realPoints.get(i).getCoordinates().y);
    }
    this.average_error_y =  (int) sum_error_y / refPoints.size();
    println("average error y", this.average_error_y);
    println(screenSize);
    
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
     if(numberOfClick==waitForClick){
         doTheClick();
         numberOfClick =0;
       }
     Thread.sleep(100);
   }
  }catch(InterruptedException e){
  e.printStackTrace();
  }
 }
 
 void doTheClick(){
   if(waitUntilNextClick==waitAfterClick){
     //clickMouse();
    // println("click");
     waitUntilNextClick=0;
   }
   waitUntilNextClick++;
 }
 void clickMouse(){
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.mouseRelease(InputEvent.BUTTON1_MASK); 
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
  public float calibX = 10;
 int convertCoordinateX(int x){
   
   int screenWidth = (int) screenSize.getWidth();
  // int newX = (x + x*(abs(defaultResolutionX - screenWidth)/defaultResolutionX)) + int(startPoint.x) ;
   x= x - int(startPoint.x);
   int newX=0;
   if(x>=0){
     float drF = (float) defaultResolutionX;
     float scF = (float) screenWidth;
     
    newX = (int)(((float)x + (float)x*(abs(drF - scF)/drF))) ;
   }
   int pondered =0;
   if(newX >500){
     pondered =(int) (newX*(1 / Math.pow(0.01,((float)newX/100000.00)))); 
   }else if(newX <400 && newX>=200){
     pondered =(int) (newX-calibX*((newX*(1 / Math.pow(0.01,((float)newX/100000.00)))-newX)));
   }else if(newX <200){
     pondered =(int) (newX-(calibX)*((newX*(1 / Math.pow(0.01,((float)newX/100000.00)))-newX)));
   }else{
     pondered = newX; 
   }
   //println("===================================");
   //println(Math.pow(0.01,((float) newX/100000.00)));
   
   return newX;
 }
  
 int convertCoordinateY(int y){
  // Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
   int screenHeight = (int) screenSize.getHeight();
 //  int newY = (y + y*(abs(defaultResolutionY - screenHeight)/defaultResolutionY)) - int(startPoint.y) - defaultResolutionY*(1/y);
   y= y - int(startPoint.y);
   int newY=0;
   if(y>=0){
     float drF = (float) defaultResolutionY;
     float scF = (float) screenHeight;
   newY = (int) (((float)y + (float) y*(abs(drF - scF)/drF)));
   }
   int pondered =0;
    if(newY >500){
     pondered =(int) (newY*(1 / Math.pow(0.01,((float)newY/100000.00)))); 
   }else if(newY <350 && newY >=270){
     pondered =(int) (newY-((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
    //pondered =(int) (newY-(newY/5)*((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
   }else if(newY>=230 && newY<270){
     pondered =(int) (newY-(newY/3)*((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
    //pondered =(int) (newY-((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
   
   }else if(newY>=150 && newY<230){
     pondered =(int) (newY-(newY/5)*((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
    //pondered =(int) (newY-((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
   }else if(newY<150){
     pondered =(int) (newY-(newY/3)*((newY*(1 / Math.pow(0.01,((float)newY/100000.00)))-newY)));
   }else{ 
     pondered = newY; 
   }
   println(newY, pondered);
   return newY;
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
}
