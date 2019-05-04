import controlP5.*;


class Button{
  
  ControlP5 cp5;
  boolean toggleValue = false;
  controlP5.Button bt;
  Textlabel label;
  
  
  String textActive; 
  String textNoActive;
  
  public Button(processing.core.PApplet screen, String textActive, boolean value, float positionX, float positionY, int sizeX, int sizeY, float labelX, String imageUp, String imageDown){
    PImage[] imgT = {loadImage(imageUp),loadImage(imageUp), loadImage(imageDown)};
    this.textActive = textActive;
    
    for(PImage img : imgT){
      img.resize(sizeX, sizeY);
    }
    
    cp5 = new ControlP5(screen);
   
    bt = new controlP5.Button(cp5, "");
    bt.setPosition(positionX, positionY);
   // bt.setSize(sizeX, sizeY);
    /*
    bt.setColorActive(color(52,219,78));
    bt.setColorBackground(color(210,210,210));
    bt.setColorForeground(color(255,0,0));*/
    bt.setImages(imgT);
    //bt.updateSize();
    bt.setSize(sizeX, sizeY);
    

  }
  
  void drawToggle() {
    fill(192,192,192);
    int border= 10;
    rect(width*0.8-border/2, height*0.5-border/2, bt.getWidth()+border, bt.getHeight()+border);
  
    
    this.bt.bringToFront();
  }

  void toggle(boolean theFlag) {
    if(theFlag==true) {
        
    } else {
      
    }
    println("a toggle event.");
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
