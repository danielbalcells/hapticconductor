import SimpleOpenNI.*;

import netP5.*;
import oscP5.*;
import controlP5.*;


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
ArrayList<Float> velMagBuffer;
ArrayList<Float> velMagDiffBuffer;
ArrayList<VibrationMotor> motors;
ArrayList<PVector> blipPositions;
ArrayList<Float> blipMags;
ArrayList<String> printBuffer;

int BUFFER_SIZE = 50;
int DEBUG_FLAG = 0;
float ACC_MAG_THRESH = 5;
int IMG_WIDTH = 600;
int IMG_HEIGHT = 480;
int KINECT_FPS = 100;
int VEL_MAG_BUFFER_SIZE = 5;



SimpleOpenNI kinect;

OscP5 oscP5;
NetAddress supercollider;

void setup(){
  size(IMG_WIDTH,IMG_HEIGHT);
  // Fill buffers with zeros
  initBuffers();
  // Initialize motors
  initMotors("circle",8);
  // Initialize Kinect object
  initKinect();
  
  
  // Start OSC stuff
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  
  // Initialize blip buffers
  blipPositions = new ArrayList<PVector>();
  blipPositions.add(new PVector(0,0));
  blipPositions.add(new PVector(0,0));
  
  blipMags = new ArrayList<Float>();
  blipMags.add(0.0);
  blipMags.add(0.0);

  printBuffer = new ArrayList<String>();
  printBuffer.add("instantAcc, instantVel");
  
  velMagBuffer = new ArrayList<Float>();

}

void draw(){
  frameRate(KINECT_FPS);
  // Update background
  //background(100);
  kinect.update();
  PImage rgb = kinect.rgbImage();
  image(rgb,0,0);
  // Get XY position from whatever device
  PVector xyPos;
  xyPos = getXYPosition(1);
  
  // Draw motors around moving body
  PVector chest = getJointXYPos(SimpleOpenNI.SKEL_TORSO,0);
  PVector lShoulder = getJointXYPos(SimpleOpenNI.SKEL_LEFT_SHOULDER,0);
  PVector rShoulder = getJointXYPos(SimpleOpenNI.SKEL_RIGHT_SHOULDER,0);
  PVector shoulderDist = new PVector(lShoulder.x-rShoulder.x, lShoulder.y - rShoulder.y);
  float scale = shoulderDist.mag();
  if(DEBUG_FLAG ==1){
    ellipse(lShoulder.x, lShoulder.y, 10, 10);
    ellipse(rShoulder.x, rShoulder.y, 10, 10);
  }
  
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
  
  ////current veloc & acc mags
  float instantAcc = (float)getMag(accBuffer.get(BUFFER_SIZE-1));
  float previousAcc = (float)getMag(accBuffer.get(BUFFER_SIZE-2));
  
  String printString = instantAcc+", "+currentVelMag;
  printBuffer.add(printString);
  
  // direction change
  float dirChangeAngle = PVector.angleBetween(velBuffer.get(BUFFER_SIZE-1),
                                              velBuffer.get(BUFFER_SIZE-2));
  
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  //if(avgAccMag > ACC_MAG_THRESH && currentVelMag > previousVelMag){
  //if(currentVelMag == 0 && instantAcc == 0 && instantAcc != previousAcc) {
    if(dirChangeAngle > 2*PI/3
    //currentVelMag <0.5 
    //&& instantAcc == 0
    ) {
    // Do something with this info
    // For example: draw a circle in the point where direction changed
    blipPositions.remove(0);
    blipPositions.add(new PVector(mouseX,mouseY));
    
    blipMags.remove(0);
    blipMags.add((float)avgVelMag);
    
    float index = map((float)averageAngle,-PI/2,PI/2,0.0,7.0);
    //println(index);
    motors.get(int(index)).vibrationOn();
    OscMessage myMessage = new OscMessage("/HapticBlip");
    myMessage.add(index);
      oscP5.send(myMessage, supercollider);
  }
  println("instant acc " + instantAcc);
  println("instant vel " + currentVelMag);
  // Update motors positions and size so they are around the body
  updateMotors(chest.x, chest.y, scale);
  
  for (VibrationMotor v: motors) {
    v.update();
    v.display();
  }
  
  for (PVector p : blipPositions){
    ellipse(p.x,p.y,10,10);
  }
  
  for(int i = 0; i < blipPositions.size();i++){
    int size = (int)map((float)blipMags.get(i),0.0,10.0,10.0,30.0);
    ellipse(blipPositions.get(i).x,blipPositions.get(i).y,size,size);
  }
  
//  text("avgAccMag: ",50,50);
//  text(avgVelMag + "",150,50);
  
    for (int i = 0; i < BUFFER_SIZE-1; i++) {
    
    float instantAcc2 = (float)getMag(accBuffer.get(i));
    float instantVel = (float)getMag(velBuffer.get(i));
    int size = 5;
    size = (int)map(instantAcc2,0.0,10.0,5.0,20.0);
    fill(255);
    strokeWeight(1);
    if (instantVel < 1.5) {
      size = 25;
      fill(color(250,0,0));
      }
      if (instantAcc2 <1) {
        strokeWeight(5);
        
      }
      
 //         } else {
//      fill(255);
 //   }
    ellipse(xyBuffer.get(i).x,xyBuffer.get(i).y,size,size);
     
  }
  /*
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  if(avgAccMag > ACC_MAG_THRESH && currentVelMag > previousVelMag){
    // Do something with this info
    // For example: draw a circle in the point where direction changed
  }
  
  fill(255, 0, 0);
  */
  ellipse(xyPos.x, xyPos.y, 10, 10);/*
  
  text((float)(angle),50,50);
  //println((angle));
  fill(255);
  translate(width/2,height/2);
  rotate((float)(averageAngle));
  line(0,0,width/2,0);*/
  
  if(mousePressed){
    String[] outputArray = new String[printBuffer.size()];
    printBuffer.toArray(outputArray);
    saveStrings("test.csv", outputArray);
  }
}
