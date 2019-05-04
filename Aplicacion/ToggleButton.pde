import controlP5.*;


class ToggleButton{
  
  ControlP5 cp5;
  boolean toggleValue = false;
  Toggle tg;
  Textlabel label;
  
  String textActive; 
  String textNoActive;
  PImage[] imgT = {loadImage("data/sound_off.png"),loadImage("data/sound_on.png"), loadImage("data/sound_on.png")};
  
  public ToggleButton(processing.core.PApplet screen, String textActive, String textNoActive, boolean value, float positionX, float positionY, int sizeX, int sizeY){
    this.textActive = textActive;
    this.textNoActive = textNoActive;
    for(PImage img : imgT){
      img.resize(sizeX, sizeY);
    }
    
    cp5 = new ControlP5(screen);

    tg = new Toggle(cp5, "");
    tg.setPosition(positionX, positionY);
    /*
    tg.setSize(sizeX, sizeY);
    tg.setValue(value);
    tg.setMode(ControlP5.SWITCH);
    tg.setColorActive(color(52,219,78));
    tg.setColorBackground(color(210,210,210));
    */
    tg.setValue(value);
    tg.setMode(ControlP5.SWITCH);  
    tg.setImages(this.imgT);
    tg.setSize(sizeX, sizeY);

  }
  
  void drawToggle() {
    fill(192,192,192);
    int border= 10;
    rect(width*0.8-border/2, height*0.5-border/2, tg.getWidth()+border, tg.getHeight()+border);
  
    
    this.tg.bringToFront();
  }

  void toggle(boolean theFlag) {
    if(theFlag==true) {
        
    } else {
      
    }
    println("a toggle event.");
  }
  
  boolean getValue(){
    if(tg.getBooleanValue()) {
      tg.setColorActive(color(52,219,78));
    } else {
      tg.setColorActive(color(219,25,39));
    }
    return this.tg.getValue() == 1; 
  }
  
  void hide(){
    this.tg.hide();
  }
  void show(){
    this.tg.show();
  }
  
  
  
}
