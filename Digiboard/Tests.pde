class Test {

  MouseManager mouseManager;
  Board board;

  public Test() {
    this.mouseManager = new MouseManager(640, 480);
    this.board = new Board(this.mouseManager);
  }
  void run() {

    pointRedInsideBoundingBox();
    calculateDifferenceBetweenColors();
    areNearColors();
    areAllNearColors();
    areSamePlace();
    convertCoordinate();
    exit();
  }

  private void setMouseManager(int bbWidth, int bbHeight, PVector bbStartPoint) {
    mouseManager.setDefaultResolutionX(int(bbWidth));
    mouseManager.setDefaultResolutionY(int(bbHeight));
    mouseManager.setDefaultStartPoint(bbStartPoint);
  }

  private void pointRedInsideBoundingBox() {
    int bbX=200;
    int bbY=100;
    PVector startPoint = new PVector(5, 5);
    setMouseManager(bbX, bbY, startPoint);
    board.setConstants();
    println("Is detected point red inside bounding box?");
    println("Bounding Box: "+bbX+"x"+bbY+ ". Starting point: "+startPoint.toString());
    try {
      assert board.isInsideBB(10, 10): 
      "Expected TRUE and result is "+ board.isInsideBB(10, 10);
      println("  Point 10,10. Expected TRUE and result is ", board.isInsideBB(10, 10));

      assert !board.isInsideBB(0, 2): 
      "Expected FALSE and result is "+ board.isInsideBB(0, 2);
      println("  Point 0,2. Expected FALSE and result is ", board.isInsideBB(0, 2));

      assert board.isInsideBB(5, 5): 
      "Expected TRUE and result is "+ board.isInsideBB(5, 5);
      println("  Point 5,5. Expected TRUE and result is ", board.isInsideBB(5, 5));

      assert board.isInsideBB(205, 105): 
      "Expected TRUE and result is "+ board.isInsideBB(205, 105);
      println("  Point 205,105. Expected TRUE and result is ", board.isInsideBB(205, 105));

      assert !board.isInsideBB(205, 106): 
      "Expected FALSE and result is "+ board.isInsideBB(205, 106);
      println("  Point 205,106. Expected FALSE and result is ", board.isInsideBB(205, 106));

      println();
    }
    catch(AssertionError e) {
      System.err.println(e);
      exit();
    }
  }

  private void calculateDifferenceBetweenColors() {
    color referenceA = color(100, 150, 100);
    color referenceB = color(150, 100, 150);

    this.board.setColorDetectionCenter(referenceA);
    this.board.setColorDetectionCorner(referenceB);

    println("Calculate difference between selected colors");
    println("ColorA: "+referenceA+". ColorB: "+referenceB);
    try {
      assert board.calculateDifference(color(200, 200, 200)) == 300: 
      "Expected 300 and result is "+ board.calculateDifference(color(200, 200, 200));
      println("  Color rgb(200,200,200). Expected 300 and result is ", board.calculateDifference(color(200, 200, 200)));

      assert board.calculateDifference(color(150, 150, 150)) == 150: 
      "Expected 300 and result is "+ board.calculateDifference(color(150, 150, 150));
      println("  Color rgb(150,150,150). Expected 150 and result is ", board.calculateDifference(color(150, 150, 150)));

      println();
    }
    catch(AssertionError e) {
      System.err.println(e);
      exit();
    }
  }

  private void areNearColors() {
    println("Are colors near between them? (Just one component of RGB)");
    try {
      assert !board.areNearColors(40, 44): 
      "Expected FALSE and result is "+ board.areNearColors(40, 44);
      println("  ColorA:40, colorB:44. Expected FALSE and result is ", board.areNearColors(40, 44));

      assert !board.areNearColors(44, 40): 
      "Expected FALSE and result is "+ board.areNearColors(44, 40);
      println("  ColorA:44, colorB:40. Expected FALSE and result is ", board.areNearColors(44, 40));

      assert board.areNearColors(41, 44): 
      "Expected TRUE and result is "+ board.areNearColors(41, 44);
      println("  ColorA:41, colorB:44. Expected TRUE and result is ", board.areNearColors(41, 44));


      println();
    }
    catch(AssertionError e) {
      System.err.println(e);
      exit();
    }
  }

  private void areAllNearColors() {
    color referenceA = color(100, 150, 100);
    color referenceB = color(150, 100, 150);

    this.board.setColorDetectionCenter(referenceA);
    this.board.setColorDetectionCorner(referenceB);

    println("Are colors near between them? (Three components of RGB)");
    println("ColorA: "+referenceA+". ColorB: "+referenceB);
    try {
      assert board.areAllNear(color(103, 153, 103)): 
      "Expected TRUE and result is "+ board.areAllNear(color(103, 153, 103));
      println("  Expected TRUE and result is ", board.areAllNear(color(103, 153, 103)));

      assert !board.areAllNear(color(105, 153, 103)): 
      "Expected FALSE and result is "+ board.areAllNear(color(105, 153, 103));
      println("  Expected FALSE and result is ", board.areAllNear(color(105, 153, 103)));

      assert !board.areAllNear(color(103, 155, 103)): 
      "Expected FALSE and result is "+ board.areAllNear(color(103, 155, 103));
      println("  Expected FALSE and result is ", board.areAllNear(color(103, 155, 103)));

      assert !board.areAllNear(color(103, 153, 105)): 
      "Expected FALSE and result is "+ board.areAllNear(color(103, 153, 105));
      println("  Expected FALSE and result is ", board.areAllNear(color(103, 153, 105)));

      assert !board.areAllNear(color(155, 103, 153)): 
      "Expected FALSE and result is "+ board.areAllNear(color(155, 103, 153));
      println("  Expected FALSE and result is ", board.areAllNear(color(155, 103, 153)));

      assert !board.areAllNear(color(153, 105, 153)): 
      "Expected FALSE and result is "+ board.areAllNear(color(153, 105, 153));
      println("  Expected FALSE and result is ", board.areAllNear(color(153, 105, 153)));

      assert !board.areAllNear(color(153, 103, 155)): 
      "Expected FALSE and result is "+ board.areAllNear(color(153, 103, 155));
      println("  Expected FALSE and result is ", board.areAllNear(color(153, 103, 155)));

      println();
    }
    catch(AssertionError e) {
      System.err.println(e);
      exit();
    }
  }

  private void areSamePlace() {
    int[] click = {50, 50};
    println("Are clicks near between them?");
    try {
      assert mouseManager.samePlace(69, 69, click): 
      "Expected TRUE and result is "+ mouseManager.samePlace(69, 69, click);
      println("  Expected TRUE and result is ", mouseManager.samePlace(69, 69, click));

      assert !mouseManager.samePlace(70, 69, click): 
      "Expected FALSE and result is "+ mouseManager.samePlace(70, 69, click);
      println("  Expected FALSE and result is ", mouseManager.samePlace(70, 69, click));

      assert !mouseManager.samePlace(69, 70, click): 
      "Expected FALSE and result is "+ mouseManager.samePlace(69, 70, click);
      println("  Expected FALSE and result is ", mouseManager.samePlace(69, 70, click));

      println();
    }
    catch(AssertionError e) {
      System.err.println(e);
      exit();
    }
  }

  private void convertCoordinate() {
    println("Convert coordinate from camera resolution to computer's resolution");
    try {
      assert mouseManager.convertCoordinate(10, 1000, 0, 100) ==100: 
      "Expected 100 and result is "+ mouseManager.convertCoordinate(10, 1000, 0, 100);
      println("  Expected 100 and result is "+ mouseManager.convertCoordinate(10, 1000, 0, 100));

      assert mouseManager.convertCoordinate(0, 1000, 0, 100) ==0: 
      "Expected 0 and result is "+ mouseManager.convertCoordinate(0, 1000, 0, 100);
      println("  Expected 0 and result is "+ mouseManager.convertCoordinate(0, 1000, 0, 100));

      println();
    }
    catch(AssertionError e) {
      System.err.println(e);
      exit();
    }
  }
}
