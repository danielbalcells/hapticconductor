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
*/
ArrayList<PVector> xyBuffer;
ArrayList<PVector> velBuffer;
ArrayList<PVector> accBuffer;
ArrayList<Float> angleBuffer;
ArrayList<VibrationMotor> motors;
int BUFFER_SIZE = 50;
int DEBUG_FLAG = 0;
float ACC_MAG_THRESH = 5;
double angle = 0;
ArrayList<PVector> blipPositions;
ArrayList<Float> blipMags;

OscP5 oscP5;
NetAddress supercollider;

void setup(){
  size(600,600);
  // Fill buffers with zeros
  initBuffers();
  initMotors("circle",8);

  
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  
  blipPositions = new ArrayList<PVector>();
  blipPositions.add(new PVector(0,0));
  blipPositions.add(new PVector(0,0));
  
  blipMags = new ArrayList<Float>();
  blipMags.add(0.0);
  blipMags.add(0.0);
  
}

void draw(){
  background(100);
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
  
  //Get current an previous positions
  PVector currentPosition = xyBuffer.get(BUFFER_SIZE-1);
  PVector previousPosition = xyBuffer.get(BUFFER_SIZE-2);
  
  //current angle
  float currentAngle = angleBuffer.get(BUFFER_SIZE-1);
  float averageAngle = getBufferFloatAverage(angleBuffer);
  
  ////current veloc & acc mags
  float instantAcc = (float)getMag(accBuffer.get(BUFFER_SIZE-1));
  float previousAcc = (float)getMag(accBuffer.get(BUFFER_SIZE-2));
  
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  //if(avgAccMag > ACC_MAG_THRESH && currentVelMag > previousVelMag){
  if(currentVelMag == 0 && instantAcc == 0 && instantAcc != previousAcc) {
    // Do something with this info
    // For example: draw a circle in the point where direction changed
    blipPositions.remove(0);
    blipPositions.add(new PVector(mouseX,mouseY));
    
    blipMags.remove(0);
    blipMags.add((float)avgVelMag);
    
    float index = map((float)averageAngle,-PI/2,PI/2,0.0,7.0);
    println(index);
    motors.get(int(index)).vibrationOn();
    OscMessage myMessage = new OscMessage("/HapticBlip");
    myMessage.add(index);
      oscP5.send(myMessage, supercollider);
  }
  
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
  
  text("avgAccMag: ",50,50);
  text(avgVelMag + "",150,50);
  
  //fill(255);
  //translate(width/2,height/2);
  //rotate((float)(averageAngle));
  //line(0,0,width/2,0);
  
  //for (int i = 0; i < BUFFER_SIZE-1; i++) {
    
  //  float instantAcc2 = (float)getMag(accBuffer.get(i));
  //  float instantVel = (float)getMag(velBuffer.get(i));
  //  int size = 5;
  //  size = (int)map(instantAcc2,0.0,10.0,5.0,20.0);
  //  if (instantAcc == 0) {
  //    size = 25;
  //    fill(color(250,0,0));
  //    if (instantVel ==0) {
  //      fill(color(0,0,250));
  //      ellipse(xyBuffer.get(i).x,xyBuffer.get(i).y,size,size);
  //    }
      
      
  //  } else {
  //    fill(255);
  //  }
    
     
  //}
  
  
}
