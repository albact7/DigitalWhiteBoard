import controlP5.*;


class ToggleButton{
  
  ControlP5 cp5;
  boolean toggleValue = false;
  Toggle tg;
  Textlabel label;
  
  String textActive; 
  String textNoActive;
  PImage[] imgT = {loadImage("data/tg_off.png"),loadImage("data/tg_on.png"), loadImage("data/tg_on.png")};
  
  public ToggleButton(processing.core.PApplet screen, String textActive, String textNoActive, boolean value, float positionX, float positionY, int sizeX, int sizeY){
    this.textActive = textActive;
    this.textNoActive = textNoActive;
    for(PImage img : imgT){
      img.resize(sizeX, sizeY);
    }
    
    cp5 = new ControlP5(screen);
    label = cp5.addTextlabel(this.textActive)
                      .setText(textActive)
                      .setColorValue(0xffffffff)
                      .setFont(createFont("Calibri",45))
                      ;
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
    
    label.setPosition(positionX,positionY + sizeY+10);
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
      label.setText(this.textActive);
    } else {
      tg.setColorActive(color(219,25,39));
      label.setText(this.textNoActive);
    }
    return this.tg.getValue() == 1; 
  }
  
  void hide(){
    this.tg.hide();
    this.label.hide();
  }
  void show(){
    this.tg.show();
    this.label.show();
  }
  
  
  
}
