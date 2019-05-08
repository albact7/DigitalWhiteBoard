import controlP5.*;


class Button{
  
  ControlP5 cp5;
  boolean toggleValue = false;
  controlP5.Button bt;
  String textActive; 
  String textNoActive;
  
  public Button(processing.core.PApplet screen, String textActive, float positionX, float positionY, int sizeX, int sizeY, String imageUp, String imageDown){
    PImage[] imgT = {loadImage(imageUp),loadImage(imageUp), loadImage(imageDown)};
    this.textActive = textActive;
    
    for(PImage img : imgT){
      img.resize(sizeX, sizeY);
    }
    
    cp5 = new ControlP5(screen);
   
    bt = new controlP5.Button(cp5, "");
    bt.setPosition(positionX, positionY);
    bt.setImages(imgT);
    bt.setSize(sizeX, sizeY);
  }
  
  void drawToggle() {
    fill(192,192,192);
    int border= 10;
    rect(width*0.8-border/2, height*0.5-border/2, bt.getWidth()+border, bt.getHeight()+border);
    this.bt.bringToFront();
  }
  
  boolean getValue(){
    return this.bt.getValue() == 1; 
  }
  
  boolean isPressed(){
     return this.bt.isPressed(); 
  }
  
  void hide(){
    this.bt.hide();
  }
  void show(){
    this.bt.show();
  }
}
