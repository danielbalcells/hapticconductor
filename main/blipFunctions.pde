int isBlip() {

  if (avgAccMag > ACC_MAG_THRESH) {
    return 1;
  } else {
    return 0;
  }

  // OLD STUFF
  // Detect change in direction if:
  //   -Acceleration magnitude is big enough
  //   -Velocity magnitude is increasing
  //if (avgAccMag > ACC_MAG_THRESH //&& currentVelMag > previousVelMag
  //if(currentVelMag == 0 && instantAcc == 0 && instantAcc != previousAcc) {
  //if(dirChangeAngle > 2*PI/3
  //currentVelMag <0.5 
  //&& instantAcc == 0
  //)
}

void onBlip() {
  blipPositions.remove(0);
  blipPositions.add(new PVector(mouseX, mouseY));

  blipMags.remove(0);
  blipMags.add((float)avgAccMag);

  float index = map((float)averageAngle, -PI/2, PI/2, 0.0, 7.0);
  //println(index);
  motors.get(int(index)).vibrationOn();
  OscMessage myMessage = new OscMessage("/HapticBlip");
  myMessage.add(index);
  oscP5.send(myMessage, supercollider);
}

