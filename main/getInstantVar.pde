/*
  Compute instantaneous first-order derivative of the last elements of a buffer.
*/

PVector getInstantVar(ArrayList<PVector> buffer){
  PVector currentFrame = buffer.get(buffer.size()-1);
  PVector previousFrame = buffer.get(buffer.size()-2);
  
  float changeinX = currentFrame.x - previousFrame.x;
  float changeinY = currentFrame.y - previousFrame.y;
  
  return new PVector(changeinX,changeinY);
}