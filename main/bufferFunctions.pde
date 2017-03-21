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
  
  
  // Initialize blip buffers
  blipPositions = new ArrayList<PVector>();
  blipPositions.add(new PVector(0, 0));
  blipPositions.add(new PVector(0, 0));

  blipMags = new ArrayList<Float>();
  blipMags.add(0.0);
  blipMags.add(0.0);

  printBuffer = new ArrayList<String>();
  printBuffer.add("instantAcc, instantVel");
}

/*
  Update all global variables and buffers based on current XY position
  Calls function instantVar to compute first-order derivatives.
*/

void updateVariables(){
  
  // Update skeleton
  chest = getJointXYPos(SimpleOpenNI.SKEL_TORSO, 0);
  lShoulder = getJointXYPos(SimpleOpenNI.SKEL_LEFT_SHOULDER, 0);
  rShoulder = getJointXYPos(SimpleOpenNI.SKEL_RIGHT_SHOULDER, 0);
  rHand = getJointXYPos(SimpleOpenNI.SKEL_RIGHT_HAND, 0);
  lHand = getJointXYPos(SimpleOpenNI.SKEL_LEFT_HAND, 0);
  shoulderScale = PVector.dist(lShoulder, rShoulder);
  
  if(rHand.x != 0 && rHand.y != 0){
    TRACKING_SOMETHING=true;
  }else{
    TRACKING_SOMETHING=false;
  } 
  
  // Update movement buffers
  xyBuffer.remove(0);
  xyBuffer.add(rHand);
  
  // Current veloc & acc mags
  currentVel = getInstantVar(xyBuffer);
  instantAcc = (float)getMag(accBuffer.get(BUFFER_SIZE-1));
  previousAcc = (float)getMag(accBuffer.get(BUFFER_SIZE-2));
  
  velBuffer.remove(0);
  velBuffer.add(currentVel);
  
  accBuffer.remove(0);
  accBuffer.add(getInstantVar(velBuffer));
  
  angleBuffer.remove(0);
  angleBuffer.add((float)vectorAngle(getInstantVar(xyBuffer)));
  
  // Average buffers to smooth out values
  avgVelVec = getVectorAverage(velBuffer);
  avgAccVec = getVectorAverage(accBuffer);

  // Get magnitude of averaged vel and acc vectors
  avgVelMag = getMag(avgVelVec);
  avgAccMag = getMag(avgAccVec);

  // Get magnitude of instantaneous vel vectors for t=now and t=now-1
  currentVelMag = getMag(velBuffer.get(BUFFER_SIZE-1));
  previousVelMag = getMag(velBuffer.get(BUFFER_SIZE-2));

  // Get current an previous positions
  currentPosition = xyBuffer.get(BUFFER_SIZE-1);
  previousPosition = xyBuffer.get(BUFFER_SIZE-2);

  // Current angle
  currentAngle = angleBuffer.get(BUFFER_SIZE-1);
  averageAngle = getBufferFloatAverage(angleBuffer);

  
  
  // Change in direction
  dirChangeAngle = PVector.angleBetween(velBuffer.get(BUFFER_SIZE-1), 
                                        velBuffer.get(BUFFER_SIZE-2));
  
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
