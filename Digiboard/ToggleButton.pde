import controlP5.*;


class ToggleButton implements InterfaceComponent{

  ControlP5 cp5;
  Toggle tg;  
  PImage[] imgT = {loadImage("data/sound_off.png"), loadImage("data/sound_on.png"), loadImage("data/sound_on.png")};

  public ToggleButton(processing.core.PApplet screen, boolean value, float positionX, float positionY, int sizeX, int sizeY) {
    for (PImage img : imgT) {
      img.resize(sizeX, sizeY);
    }

    cp5 = new ControlP5(screen);

    tg = new Toggle(cp5, "");
    tg.setPosition(positionX, positionY);
    tg.setValue(value);
    tg.setMode(ControlP5.SWITCH);  
    tg.setImages(this.imgT);
    tg.setSize(sizeX, sizeY);
  }

  void drawBtn() {
    fill(192, 192, 192);
    int border= 10;
    rect(width*0.8-border/2, height*0.5-border/2, tg.getWidth()+border, tg.getHeight()+border);
    this.tg.bringToFront();
  }

  boolean isPressed() {
    if (tg.getBooleanValue()) {
      tg.setColorActive(color(52, 219, 78));
    } else {
      tg.setColorActive(color(219, 25, 39));
    }
    return this.tg.getValue() == 1;
  }

  void hide() {
    this.tg.hide();
  }
  void show() {
    this.tg.show();
  }
}
