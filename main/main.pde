/*  
  Global variables
    -Buffers for:
      -Position
      -1st order derivatives (velocity)
      -2nd order derivatives (acceleration)
    -Buffer size 
    -Debug flag
*/
ArrayList<PVector> xyBuffer;
ArrayList<PVector> velBuffer;
ArrayList<PVector> accBuffer;
int BUFFER_SIZE = 20;
int DEBUG_FLAG = 0;
float ACC_MAG_THRESH = 5;

void setup(){
  // Fill buffers with zeros
  initBuffers();
  size(600,600);
}

void draw(){
  // Get XY position from whatever device
  PVector xyPos;
  xyPos = getXYPosition(0);
  
  // Use current position to update velocity and acceleration buffers
  updateBuffers(xyPos.x, xyPos.y);
  
  // Average buffers to smooth out values
  PVector avgVelVec = getVectorAverage(velBuffer);
  PVector avgAccVec = getVectorAverage(accBuffer);
  
  // Get magnitude of averaged vel and acc vectors
  double avgVelMag = getMag(avgVelVec);
  double avgAccMag = getMag(avgAccVec);
  
  // Get magnitude of instantaneous vel vectors for t=now and t=now-1
  double currentVelMag = getMag(velBuffer.get(BUFFER_SIZE-1));
  double previousVelMag = getMag(velBuffer.get(BUFFER_SIZE-2));
  
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  if(avgAccMag > ACC_MAG_THRESH && currentVelMag > previousVelMag){
    // Do something with this info
    // For example: draw a circle in the point where direction changed
  }
}