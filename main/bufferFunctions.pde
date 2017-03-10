/*
  Initialize buffers setting all their elements to zero.
*/

void initBuffers(){
  xyBuffer = new ArrayList<PVector>();
  velBuffer = new ArrayList<PVector>();
  accBuffer = new ArrayList<PVector>();
  
  for(int i = 0; i<BUFFER_SIZE;i++){
    xyBuffer.add(new PVector(0,0));
    velBuffer.add(new PVector(0,0));
    accBuffer.add(new PVector(0,0));
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
  //Dani's Code
  //velBuffer.add(instantVar(xyBuffer));
  
  accBuffer.remove(0);
  accBuffer.add(getInstantVar(velBuffer));
  //Dani's Code
  //accBuffer.add(instantVar(velBuffer));
  
  if(DEBUG_FLAG == 1){
    println("xyBuffer:");
    println(xyBuffer);
    println("velBuffer:");
    println(velBuffer);
    println("accBuffer:");
    println(accBuffer);
  }
}