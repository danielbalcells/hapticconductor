/*
  Initialize buffers setting all their elements to zero.
*/

void initBuffers(){
  // Hopefully unnecessary at some point
  //---------------------------------
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
  // End of hopefully unnecessary stuff
  // ----------------------------------
  
  // Populate filter coefficients
  /*lpfSoftA = new ArrayList<Float>();
  lpfSoftA.add(1.0f);
  lpfSoftA.add(-1.2982434912f);
  lpfSoftA.add(1.4634092217f);
  lpfSoftA.add(-0.7106501488f);
  lpfSoftA.add(0.2028836637f);
  lpfSoftB = new ArrayList<Float>();
  lpfSoftB.add(0.1851439645f);
  lpfSoftB.add(0.1383283833f);
  lpfSoftB.add(0.1746892243f);
  lpfSoftB.add(0.1046627716f);
  lpfSoftB.add(0.0464383730f);*/
  
  // Buffers to store previous IIR inputs (XY pos) and outputs (XY acc)
  iirXin = new ArrayList<Float>();
  iirXout = new ArrayList<Float>();
  iirYin = new ArrayList<Float>();
  iirYout = new ArrayList<Float>();
  for(int i=0; i<IIR_BUFFER_SIZE; i++){
    iirXin.add(0.0f);
    iirXout.add(0.0f);
    iirYin.add(0.0f);
    iirYout.add(0.0f);
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
  //shoulderScale = PVector.dist(lShoulder, rShoulder);
  
  if(rHand.x != 0 && rHand.y != 0){
    TRACKING_SOMETHING=true;
  }else{
    TRACKING_SOMETHING=false;
  } 
  
  // Hopefully unnecessary at some point
  //---------------------------------
  /*
  
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
  // End of hopefully unnecessary stuff
  // ----------------------------------
  */
  
  // Compute new IIR output based on previous outputs and inputs
  /*float newIIRoutX = getIIROutput(iirXin, iirXout, lpfSoftA, lpfSoftB);
  float newIIRoutY = getIIROutput(iirYin, iirYout, lpfSoftA, lpfSoftB);*/
  // Update movement buffers
  xyBuffer.remove(0);
  xyBuffer.add(rHand);
  
  float newIIRoutX = getIIROutput(iirXin, iirXout);
  float newIIRoutY = getIIROutput(iirYin, iirYout);
  PVector newIIROutput = new PVector(newIIRoutX, newIIRoutY);
  currentIIRAccMag = newIIROutput.mag()/shoulderScale;
  fill(0);
  // Update IIR buffers
  iirXin.remove(IIR_BUFFER_SIZE-1);
  iirXout.remove(IIR_BUFFER_SIZE-1);
  iirYin.remove(IIR_BUFFER_SIZE-1);
  iirYout.remove(IIR_BUFFER_SIZE-1);
  iirXin.add(0, rHand.x);
  iirYin.add(0, rHand.y);
  iirXout.add(0, newIIRoutX);
  iirYout.add(0, newIIRoutY);
  
  previousAcc = currentAcc;
  currentAcc = nextAcc;
  nextAcc = currentIIRAccMag;
  
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

/*
  Computes the output of the IIR filter given the current inputs and outputs
  Note that x and y in this method follow IIR notation (in and out) and do not
  represent x and y position.
  */
/*float getIIROutput(ArrayList<Float> x, ArrayList<Float> y, 
                     ArrayList<Float> a, ArrayList<Float> b){
  return x.get(0) * b.get(0) + x.get(1) * b.get(1) + x.get(2) * b.get(2)
                             + x.get(3) * b.get(3) + x.get(4) * b.get(4)
     -1*(y.get(0) * a.get(1) + y.get(1) * a.get(2) + y.get(2) * a.get(3)
                             + y.get(3) * a.get(4));
}*/

float getIIROutput(ArrayList<Float> x, ArrayList<Float> y){
  return x.get(0) * lpfSoftB[0] + x.get(1) * lpfSoftB[1] + x.get(2) * lpfSoftB[2]
                             + x.get(3) * lpfSoftB[3] + x.get(4) * lpfSoftB[4]
     -1*(y.get(0) * lpfSoftA[1] + y.get(1) * lpfSoftA[2] + y.get(2) * lpfSoftA[3]
                             + y.get(3) * lpfSoftA[4]);
}

float dotProduct(float[] a, float[] b){
  float sum = 0;
  for(int i=0; i<a.length; i++){
    sum += a[i] * b[i];
  }
  return sum;
}
