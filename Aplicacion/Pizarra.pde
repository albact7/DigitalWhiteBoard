import java.awt.*;
import java.awt.event.InputEvent;
import java.util.Random;
class Board{
  
static final int defaultResolutionX = 640;
static final int defaultResolutionY = 480;

float oldMouseX,oldMouseY;

color fondo=color(255,255,128);
color colorDeteccionCentro;
color colorDeteccionEsquina;
color paleta[] = {
      color(0),
      color(255),
      color(255,0,0),
      color(0,255,0),
      color(0,0,255)
    };

int colorActual=3;    
int strokeW=10;

int ell1=1;
int selectedPoints[][];
color selectedColors[];
int point=0;
int resX = 640;
int resY = 480;

MouseManager mouseManager;
static final int waitForClick=2;
int click[]=new int [2];
int numberOfClick=0;
static final int waitAfterClick=5 ;
int waitUntilNextClick=waitAfterClick;

PVector lastRed;

Board(MouseManager mouseManager){
 this.mouseManager = mouseManager; 
}

MouseManager getMouseManager(){
   return mouseManager; 
}

void setupBoard(){  
  this.oldMouseX=0;
  this.oldMouseY=0;
}

void paint(int newMouseX, int newMouseY){
  noStroke();
  strokeWeight(strokeW);
  stroke(paleta[colorActual]);
 
  point(newMouseX,newMouseY);

  oldMouseX=newMouseX;
  oldMouseY=newMouseY; 
}
  
  
 public PVector clickOnRed(Capture video) {
    mouseManager.moveMouse(whereIsRed(video));
    return null;
 }
 
 public PVector whereIsRed(Capture video) {
    selectedPoints = new int[640*2][3];
    selectedColors = new int[640*2];
    int nearest[] = new int [2];
    float smallestDif=1000;
    boolean painted = false;
    for (int x = 0; x < 640; x++) {
      for (int y = 0; y < 480; y++) {
         int numberPix=640*y + x;
         color pixelValue = video.pixels[numberPix];
         // Determine the color of the pixel
         if (areAllNear(pixelValue)){
            if(calculateDifference(pixelValue)<smallestDif){
              painted=true;
              smallestDif = calculateDifference(pixelValue);
              nearest[0]=x;
              nearest[1]=y;              
            }
            point++;
         }
      }
    }
     if(painted){
       if( mouseManager.samePlace(nearest[0], nearest[1], click)){
         numberOfClick++;
         paint(nearest[0], nearest[1]);
         lastRed = new PVector(getCoordinateClose(click[0],nearest[0]),getCoordinateClose(click[1],nearest[1])); 
       }else{
         numberOfClick=0;
         click[0]=nearest[0];
         click[1]=nearest[1];
         paint(nearest[0], nearest[1]);
         lastRed = new PVector(nearest[0],nearest[1]);
       }
       if(numberOfClick==waitForClick){
         doTheClick();
         numberOfClick =0;
       }
       return lastRed;      
     }
     return null;
 }
 
 PVector getLastRed(){
    return this.lastRed; 
 }
 
 void doTheClick(){
   if(waitUntilNextClick==waitAfterClick){
     mouseManager.clickMouse();
     println("click");
     waitUntilNextClick=0;
   }
   waitUntilNextClick++;
 }
 
 int getCoordinateClose(int coord1, int coord2){
     return coord1 + (coord1-coord2)/2;
 }
 
 boolean isInCorner(int x, int y){
    return  (x <= defaultResolutionX/6) && (x >= defaultResolutionX*5/6) && (y <= defaultResolutionY/6) && (y >= defaultResolutionY*5/6);
 }
 
 boolean centerRed(Capture video, int nPix){
    for (int i = 1; i<10;i++){
      if(!(areSimilar(video, nPix-i)&&areSimilar(video, nPix+i)&&areSimilar(video, (nPix-i)-resX*i)&&areSimilar(video, nPix+i+resX*i)))
          return false;
    }
    return true;
 }
 
 int[] nearestPoint(){
   int nearest[] = new int [2];
   float smallestDif=1000;
   for(int i =0; i<selectedPoints.length; i++){
      if(calculateDifference(selectedColors[i])<smallestDif){  
        smallestDif = calculateDifference(selectedColors[i]);
        nearest[0]=selectedPoints[i][0];
        nearest[1]=selectedPoints[i][1];
      }
   }
   return nearest;
 }
 
 float calculateDifference(color pixelValue){
    float difRed =max(abs(red(this.colorDeteccionCentro)-red(pixelValue)),abs(red(this.colorDeteccionEsquina)-red(pixelValue)));
    float difGreen =max(abs(green(this.colorDeteccionCentro)-green(pixelValue)),abs(green(this.colorDeteccionEsquina)-green(pixelValue)));
    float difBlue =max(abs(blue(this.colorDeteccionCentro)-blue(pixelValue)),abs(blue(this.colorDeteccionEsquina)-blue(pixelValue)));
    return difRed+difGreen+difBlue;
 }
 
 void setColorDeteccionCentro(color nuevoColor) {
   this.colorDeteccionCentro = nuevoColor;
      println("r: " + red(nuevoColor) + " - g: " + green(nuevoColor) + " - b: " + blue(nuevoColor));
 }
 void setColorDeteccionEsquina(color nuevoColor) {
   this.colorDeteccionEsquina = nuevoColor;
      println("r: " + red(nuevoColor) + " - g: " + green(nuevoColor) + " - b: " + blue(nuevoColor));
 }
 
 boolean sonProximos(float color1, float color2){
   return (color1<color2 + 4 && color1 > color2 - 4);
 }
 
 boolean areAllNear(int pixelValue){
   return sonProximos(red(pixelValue), red(this.colorDeteccionCentro)) && sonProximos(blue(pixelValue), blue(this.colorDeteccionCentro)) && 
             sonProximos(green(pixelValue), green(this.colorDeteccionCentro))
             || ( sonProximos(red(pixelValue), red(this.colorDeteccionEsquina)) && sonProximos(blue(pixelValue), blue(this.colorDeteccionEsquina)) && 
             sonProximos(green(pixelValue), green(this.colorDeteccionEsquina)));
 }
 
 boolean areSimilar(Capture video, int nPix){
   color pixelValue=0;
   if(nPix<resX*resY && nPix>=0){
   pixelValue = video.pixels[nPix];
   }
   if(pixelValue==0){
     return true;
   }
  return sonProximos(red(pixelValue), red(this.colorDeteccionCentro)) && sonProximos(blue(pixelValue), blue(this.colorDeteccionCentro)) && 
             sonProximos(green(pixelValue), green(this.colorDeteccionCentro)) 
             || sonProximos(red(pixelValue), red(this.colorDeteccionEsquina)) && sonProximos(blue(pixelValue), blue(this.colorDeteccionEsquina)) && 
             sonProximos(green(pixelValue), green(this.colorDeteccionEsquina)) ;
 }
 

 
  

  
  
  
  
}
