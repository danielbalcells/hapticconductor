import SimpleOpenNI.*;
import netP5.*;
import oscP5.*;
import controlP5.*;
import java.util.Collections;

// Hopefully all of this will be unnecessary at some point
//--------------------------------------------------------
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
//float instantAcc;
//float previousAcc;
// Direction change angle taken from velocity
float dirChangeAngle;
// End of hopefully unnecessary stuff
//---------------------------------------------------------

// Buffers for input (XY pos) and output (XY acc) of the IIR filter
ArrayList<Float> iirXin;
ArrayList<Float> iirXout;
ArrayList<Float> iirYin;
ArrayList<Float> iirYout;
float currentIIRAccMag;

// IIR filter coefficients
//ArrayList<Float> lpfSoftA;
//ArrayList<Float> lpfSoftB;

//float[] lpfSoftA = {1,-1.2982434912,1.4634092217,-0.7106501488,0.2028836637};
//float[] lpfSoftB = {0.1851439645,0.1383283833,0.1746892243,0.1046627716,0.0464383730};

float[] lpfSoftA = {1, -0.8274946715, 0.8110775672, -0.3530877871, 0.06598917583};
float[] lpfSoftB = {0.1099156485, -0.1289124440, -0.0372667405, 0.0216082189, 0.0346553170};


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
float ACC_MAG_THRESH = 4.25;
int IMG_WIDTH = 600;
int IMG_HEIGHT = 480;
int KINECT_FPS = 30;
int VEL_MAG_BUFFER_SIZE = 5;
int MAX_BLIP_VIS_SIZE = 40;
boolean TRACKING_SOMETHING = false;
int IIR_BUFFER_SIZE = 5;

int BLIP_COUNTER = 0;
int FRAMES_SINCE_LAST_BLIP = 9999;
float MIN_BLIP_FRAMECOUNT = 3;

int CALIBRATION=0;
float NOISE_FLOOR=0.01;
float CALIB_FRAC = 0.5;
ArrayList<Float> calibrationBuffer = new ArrayList<Float>();
float maxCalibrationAcc=0;
float meanCalibrationAcc=0;

float previousAcc=-1;
float currentAcc=-1;
float nextAcc=-1;


SimpleOpenNI kinect;

OscP5 oscP5;
NetAddress supercollider;

void setup() {
  size(IMG_WIDTH, IMG_HEIGHT);
  //fullScreen();

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


  if (TRACKING_SOMETHING && CALIBRATION == 2) {
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
  String printString = Float.toString(currentIIRAccMag);
  printBuffer.add(printString);
  if (mousePressed) {
    String[] outputArray = new String[printBuffer.size()];
    printBuffer.toArray(outputArray);
    saveStrings("test.csv", outputArray);
  }

  if (CALIBRATION == 1) {
    calibrationBuffer.add(currentIIRAccMag);
  }
}

void mouseClicked() {
  if (mouseX > width-20 && mouseY > height-20) {
    if (CALIBRATION == 1) {
      int calibrationCounter=0;
      for (int i=0; i < calibrationBuffer.size (); i++) {
        float thisAcc = calibrationBuffer.get(i);

        if (thisAcc > NOISE_FLOOR) {
          meanCalibrationAcc += thisAcc;
          calibrationCounter++;
          if (thisAcc > maxCalibrationAcc) {
            maxCalibrationAcc = thisAcc;
          }
        }
      }
        meanCalibrationAcc = meanCalibrationAcc / (float)calibrationCounter;
        ACC_MAG_THRESH = meanCalibrationAcc;
        CALIBRATION  = 2;
        println("calibrated");
        println("max acceleration: ");
        println(maxCalibrationAcc);
        println("mean acceleration: ");
        println(meanCalibrationAcc);
        println("calibrated threshold: ");
        println(ACC_MAG_THRESH);
      }

      if (CALIBRATION==0) {
        shoulderScale = PVector.dist(lShoulder, rShoulder);
        CALIBRATION=1;
      }
    }
}
