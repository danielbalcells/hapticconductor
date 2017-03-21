boolean isBlip() {

  if (instantAcc > ACC_MAG_THRESH) {
    return true;
  } else {
    return false;
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


  // Turn on motor according to hand-to-chest angle
  float angle = getBlipToChestAngle(lHand, chest);
  float index = map(angle, PI, -PI, 0.0, 7.0);
  int selectedMotor = int(index-0.5);
 
  for(int i=0; i<8 && i != selectedMotor; i++){
    motors.get(i).vibrationOff();
  }
  motors.get(int(selectedMotor)).vibrationOn();
  OscMessage myMessage = new OscMessage("/HapticBlip");
  myMessage.add(index);
  oscP5.send(myMessage, supercollider);
  
  
}

float getBlipToChestAngle(PVector hand, PVector chest){
  return PVector.sub(hand,chest).heading();
}
