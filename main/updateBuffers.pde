/*
  Take current XY position and update 
  position, velocity and acceleration buffers.
  Calls function instantVar to compute first-order derivatives.
*/

void updateBuffers(float x,float y){
  xyBuffer.remove(0);
  xyBuffer.add(new PVector(x,y));
  
  velBuffer.remove(0);
  velBuffer.add(instantVar(xyBuffer));
  
  accBuffer.remove(0);
  accBuffer.add(instantVar(velBuffer));
  
  if(DEBUG_FLAG == 1){
    println("xyBuffer:");
    println(xyBuffer);
    println("velBuffer:");
    println(velBuffer);
    println("accBuffer:");
    println(accBuffer);
  }
}