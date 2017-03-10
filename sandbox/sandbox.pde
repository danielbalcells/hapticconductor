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
int BUFFER_SIZE = 10;
int DEBUG_FLAG = 0;
float ACC_MAG_THRESH = 5;
double angle = 0;
ArrayList<PVector> blipPositions;

OscP5 oscP5;
NetAddress supercollider;

void setup(){
  // Fill buffers with zeros
  initBuffers();
  initMotors("circle",8);
  size(600,600);
  
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  
  blipPositions = new ArrayList<PVector>();
  
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
  
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  if(avgAccMag > ACC_MAG_THRESH && currentVelMag > previousVelMag){
    // Do something with this info
    // For example: draw a circle in the point where direction changed
    blipPositions.add(new PVector(mouseX,mouseY));
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
  
  text((float)(angle),50,50);
  fill(255);
  translate(width/2,height/2);
  rotate((float)(averageAngle));
  line(0,0,width/2,0);
  
  
}