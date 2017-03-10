/*  
  Global variables
    -Buffers for:
      -Position
      -1st order derivatives (velocity)
      -2nd order derivatives (acceleration)
    -Buffer size 
    -Debug flag
    -Threshold applied on acceleration magnitude
    -Kinect stuff    
*/
ArrayList<PVector> xyBuffer;
ArrayList<PVector> velBuffer;
ArrayList<PVector> accBuffer;
ArrayList<Float> angleBuffer;
int BUFFER_SIZE = 20;
int DEBUG_FLAG = 0;
float ACC_MAG_THRESH = 5;
double angle = 0;

import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup(){
  // Fill buffers with zeros
  initBuffers();
  // Initialize Kinect object
  initKinect();
  size(600,600);
}

void draw(){
  background(100);
  // Get XY position from whatever device
  PVector xyPos;
  xyPos = getXYPosition(1);
  
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
  
  //Get current an previous positions
  PVector currentPosition = xyBuffer.get(BUFFER_SIZE-1);
  PVector previousPosition = xyBuffer.get(BUFFER_SIZE-2);
  
  //current angle
  float currentAngle = angleBuffer.get(BUFFER_SIZE-1);
  float averageAngle = getBufferFloatAverage(angleBuffer);
  
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  if(avgAccMag > ACC_MAG_THRESH && currentVelMag > previousVelMag){
    // Do something with this info
    // For example: draw a circle in the point where direction changed
  }
  
  fill(255, 0, 0);
  ellipse(xyPos.x, xyPos.y, 10, 10);
  
  text((float)(angle),50,50);
  //println((angle));
  fill(255);
  translate(width/2,height/2);
  rotate((float)(averageAngle));
  line(0,0,width/2,0);
}
