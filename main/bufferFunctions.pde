/*
  Initialize buffers setting all their elements to zero.
*/

void initBuffers(){
  xyBuffer = new ArrayList<PVector>();
  velBuffer = new ArrayList<PVector>();
  accBuffer = new ArrayList<PVector>();
  angleBuffer = new ArrayList<Float>() ;
  
  for(int i = 0; i<BUFFER_SIZE;i++){
    xyBuffer.add(new PVector(0,0));
    velBuffer.add(new PVector(0,0));
    accBuffer.add(new PVector(0,0));
    angleBuffer.add(0.0);
  } 
}

/*
  Take current XY position and update 
  position, velocity and acceleration buffers.
  Calls function instantVar to compute first-order derivatives.
*/

void updateBuffers(float x,float y){
  xyBuffer.remove(0);
  xyBuffer.add(new PVector(x,y));
  
  velBuffer.remove(0);
  velBuffer.add(getInstantVar(xyBuffer));
  
  accBuffer.remove(0);
  accBuffer.add(getInstantVar(velBuffer));
  
  angleBuffer.remove(0);
  angleBuffer.add((float)vectorAngle(getInstantVar(xyBuffer)));
  
  if(DEBUG_FLAG == 1){
    println("xyBuffer:");
    println(xyBuffer);
    println("velBuffer:");
    println(velBuffer);
    println("accBuffer:");
    println(accBuffer);
    println("angleBuffer:");
    println(angleBuffer);
  }
}

/*
  Returns the average value from an arraylist of floats.
*/
float getBufferFloatAverage(ArrayList<Float> buffer){
    float sum = 0;
    for (float f: buffer) {
      sum += f;
    }
    return sum/buffer.size();
}