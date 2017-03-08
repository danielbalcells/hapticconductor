/*
  Get XY position using the specified method.
  Available methods:
    -0: mouseX and mouseY
*/
PVector getXYPosition(int method){
  PVector xyPos = new PVector(0,0);
  
  if (method == 0){
    xyPos = new PVector(mouseX,mouseY);
  }
  
  return xyPos;
}