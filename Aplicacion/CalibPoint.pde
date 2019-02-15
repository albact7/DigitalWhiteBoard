class CalibPoint{
  
 PVector coordinates;
 boolean clicked;
 public CalibPoint(PVector coordinates){
    setCoordinates(coordinates);
 }
 
 void setCoordinates(PVector coordinates){
    this.coordinates=coordinates; 
 }
 void setClicked(boolean clicked){
    this.clicked=clicked;
 }
 boolean isClicked(){
    return this.clicked; 
 }
 PVector getCoordinates(){
    return this.coordinates; 
 }
  
}
