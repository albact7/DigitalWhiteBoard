class SeleccionColor{
  
  float x, y, radio;
  private color colorActualCentro;
  private color colorActualEsquina;
  boolean seleccionando=false;
  
  SeleccionColor(float x, float y, float radio){
    this.x=x;
    this.y=y;
    this.radio=radio;
    colorActualCentro = color(252,25,25);
  }
  
  void display(){
    fill(colorActualCentro);
    stroke(127);
    strokeWeight(5);
    ellipse(x,y,radio, radio);
  }
  
  void onMouseClick() {
    float disX = this.x - mouseX;
    float disY = this.y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < radio) {
     this.seleccionando = !this.seleccionando; 
    }
  }
  
  void cambiarColorActualCentro(color colorActual) {
    this.colorActualCentro = colorActual;
  }
  void cambiarColorActualEsquina(color colorActual) {
    this.colorActualEsquina = colorActual;
  }
}
