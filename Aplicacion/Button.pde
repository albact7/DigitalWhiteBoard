import controlP5.*;


class Button{
  
  ControlP5 cp5;
  boolean toggleValue = false;
  controlP5.Button bt;
  Textlabel label;
  PImage[] imgT = {loadImage("data/btn_purple_up.png"),loadImage("data/btn_purple_up.png"), loadImage("data/btn_purple_down.png")};
  
  String textActive; 
  String textNoActive;
  
  public Button(processing.core.PApplet screen, String textActive, boolean value, float positionX, float positionY, int sizeX, int sizeY, float labelX){
    this.textActive = textActive;
    
    for(PImage img : imgT){
      img.resize(sizeX, sizeY);
    }
    
    cp5 = new ControlP5(screen);
    label = cp5.addTextlabel(this.textActive)
                      .setText(textActive)
                      .setColorValue(0xffffffff)
                      .setFont(createFont("Calibri",45))
                      ;
    bt = new controlP5.Button(cp5, "");
    bt.setPosition(positionX, positionY);
   // bt.setSize(sizeX, sizeY);
    /*
    bt.setColorActive(color(52,219,78));
    bt.setColorBackground(color(210,210,210));
    bt.setColorForeground(color(255,0,0));*/
    bt.setImages(this.imgT);
    //bt.updateSize();
    bt.setSize(sizeX, sizeY);
    
    label.setPosition(labelX,positionY + sizeY+10);
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
    this.label.hide();
  }
  void show(){
    this.bt.show();
    this.label.show();
  }
  
  
  
}
