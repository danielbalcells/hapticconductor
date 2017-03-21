import SimpleOpenNI.*;
import netP5.*;
import oscP5.*;
import controlP5.*;

// A shitload of variables used in blip detection
// Buffers for position, velocity, acceleration vectors and magnitudes
ArrayList<PVector> xyBuffer;
ArrayList<PVector> velBuffer;
ArrayList<PVector> accBuffer;
ArrayList<Float> angleBuffer;
// Average buffers to smooth out values
PVector avgVelVec;
PVector avgAccVec;
// Magnitude of averaged vel and acc vectors
double avgVelMag;
double avgAccMag;
// Magnitude of instantaneous vel vectors for t=now and t=now-1
double currentVelMag;
double previousVelMag;
// Current and previous positions
PVector currentPosition;
PVector previousPosition;
// Current angle
float currentAngle;
float averageAngle;
// Current veloc & acc mags
PVector currentVel;
float instantAcc;
float previousAcc;
// Direction change angle taken from velocity
float dirChangeAngle;

// XY positions of parts of the body
PVector chest;
PVector lShoulder;
PVector rShoulder;
PVector rHand;
PVector lHand;
float shoulderScale;

// Placeholder vibration motors used to visualize feedback
ArrayList<VibrationMotor> motors;
// Buffers for detected blips
ArrayList<PVector> blipPositions;
ArrayList<Float> blipMags;
ArrayList<String> printBuffer;

// Constants used throughout the code
int BUFFER_SIZE = 50;
int DEBUG_FLAG = 0;
float ACC_MAG_THRESH = 5;
int IMG_WIDTH = 600;
int IMG_HEIGHT = 480;
int KINECT_FPS = 100;
int VEL_MAG_BUFFER_SIZE = 5;
int MAX_BLIP_VIS_SIZE = 40;
boolean TRACKING_SOMETHING = false;

int BLIP_COUNTER = 0;
int FRAMES_SINCE_LAST_BLIP = 9999;
float MIN_BLIP_FRAMECOUNT = (float)KINECT_FPS/10.0;

SimpleOpenNI kinect;

OscP5 oscP5;
NetAddress supercollider;

void setup() {
  size(IMG_WIDTH, IMG_HEIGHT);

  // Fill buffers with zeros
  initBuffers();

  // Initialize motors
  initMotors("circle", 8);

  // Initialize Kinect object
  initKinect();

  // Initialize serial connection
  initSerial();

  // Start OSC stuff
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
}

void draw() {
  frameRate(KINECT_FPS);
  kinect.update();
  PImage rgb = kinect.rgbImage();
  image(rgb, 0, 0);

  // Update buffers and other frame-wise global variables
  updateVariables();
  FRAMES_SINCE_LAST_BLIP++;


  if (TRACKING_SOMETHING) {
    // If there is a blip, do whatever
    if (FRAMES_SINCE_LAST_BLIP > MIN_BLIP_FRAMECOUNT) {
      if (isBlip()) {
        FRAMES_SINCE_LAST_BLIP=0;
        onBlip();
      }
    }
  } 
  // Update on-screen visualizations of feedback and blip detection
  updateVisuals();

  // Debug saves to a file
  String printString = instantAcc+", "+currentVelMag;
  printBuffer.add(printString);
  if (mousePressed) {
    String[] outputArray = new String[printBuffer.size()];
    printBuffer.toArray(outputArray);
    saveStrings("test.csv", outputArray);
  }
}

