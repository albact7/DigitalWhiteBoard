
class Test{
 
   MouseManager mouseManager;
   Board board;
    
   public Test(){
     this.mouseManager = new MouseManager(640, 480);
     this.board = new Board(this.mouseManager);
   }
   void run(){
     pointRedInsideBoundingBox();
     
     exit();
   }
   
   private void setMouseManager(int bbWidth, int bbHeight, PVector bbStartPoint){
      mouseManager.setDefaultResolutionX(int(bbWidth));
      mouseManager.setDefaultResolutionY(int(bbHeight));
      mouseManager.setDefaultStartPoint(bbStartPoint);
   }
    
   void pointRedInsideBoundingBox(){
      int bbX=200;
      int bbY=100;
      PVector startPoint = new PVector(5,5);
      setMouseManager(bbX, bbY, startPoint);
      board.setConstants();
      println("Is detected point red inside bounding box?");
      println("Bounding Box: "+bbX+"x"+bbY+ ". Starting point: "+startPoint.toString());
      println("Point 10,10. Expected TRUE and result is ", board.isInsideBB(10,10));
      println("Point 0,2. Expected FALSE and result is ", board.isInsideBB(0,2));
      println("Point 5,5. Expected TRUE and result is ", board.isInsideBB(5,5));
      println("Point 205,105. Expected TRUE and result is ", board.isInsideBB(205,105));
      println("Point 205,106. Expected FALSE and result is ", board.isInsideBB(205,106));
   }
 
  
}
