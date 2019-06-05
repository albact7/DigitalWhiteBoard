import controlP5.*;


class Button implements InterfaceComponent {

  private ControlP5 cp5;
  private controlP5.Button bt; 

  public Button(processing.core.PApplet screen, String textActive, float positionX, float positionY, int sizeX, int sizeY, String imageUp, String imageDown) {
    PImage[] imgT = {loadImage(imageUp), loadImage(imageUp), loadImage(imageDown)};

    for (PImage img : imgT) {
      img.resize(sizeX, sizeY);
    }

    cp5 = new ControlP5(screen);

    bt = new controlP5.Button(cp5, textActive);
    bt.setPosition(positionX, positionY);
    bt.setImages(imgT);
    bt.setSize(sizeX, sizeY);
  }

  void drawBtn() {
    fill(192, 192, 192);
    int border= 10;
    rect(width*0.8-border/2, height*0.5-border/2, bt.getWidth()+border, bt.getHeight()+border);
    this.bt.bringToFront();
  }

  boolean isPressed() {
    return this.bt.isPressed();
  }

  void hide() {
    this.bt.hide();
  }
  void show() {
    this.bt.show();
  }
}
