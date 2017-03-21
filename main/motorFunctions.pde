/*
  Initialises motor objects
 */

void initMotors(String mode, int size) {

  motors = new ArrayList<VibrationMotor>();
  for (int i = 0; i < size; i++) {
    if (mode == "line") {
      motors.add(new VibrationMotor(((width/size)/2)+(i*(width/size)), height/2, 50, i));
    } else if (mode == "circle") {
      float posx = width/2+200*sin(TWO_PI/float(size)*i);
      float posy = height/2-200*cos(TWO_PI/float(size)*i);
      motors.add(i,new VibrationMotor(int(posx), int(posy), 50, i));
    }
  }
}


/*
  Sets position and size of motor objects around moving body
 */

void updateMotors(float centerX, float centerY, float scale) {

  int size = motors.size();
  for (int i = 0; i < size; i++) {
    VibrationMotor thisMotor = motors.get(i);
    float posx = centerX+scale*sin(TWO_PI/float(size)*i);
    float posy = centerY-scale*cos(TWO_PI/float(size)*i);
    PVector newPos = new PVector(posx, posy);
    thisMotor.setPos(newPos);
    thisMotor.setDiameter(int(50*scale/180));
    motors.set(i, thisMotor);
  }
}

