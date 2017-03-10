/*
  Return the magnitude of a vector
*/

double getMag(PVector v){
  double norm = Math.sqrt(Math.pow(v.x, 2) + Math.pow(v.y, 2));
  return norm;
}

/*
  Loop through the elements of a vector and returns their average.
*/

PVector getVectorAverage(ArrayList<PVector> buffer){
  float xSum=0;
  float ySum=0;
  
  for(int i = 0; i < buffer.size();i++){
    xSum+= buffer.get(i).x;
    ySum+= buffer.get(i).y;
  }
  return new PVector(xSum/buffer.size(),ySum/buffer.size());
}

/*
  Return the angle of a velocity vector (work out units & constraints)
*/
double vectorAngle(PVector v){
  if(velBuffer.get(BUFFER_SIZE-1).y == 0 && velBuffer.get(BUFFER_SIZE-1).x == 0) {
    return 0;
  } else {
    return atan(v.y/v.x);
  }
}

/*
  Compute instantaneous first-order derivative of the last elements of a buffer.
*/

PVector getInstantVar(ArrayList<PVector> buffer){
  PVector currentFrame = buffer.get(buffer.size()-1);
  PVector previousFrame = buffer.get(buffer.size()-2);
  
  float changeinX = currentFrame.x - previousFrame.x;
  float changeinY = currentFrame.y - previousFrame.y;
  
  return new PVector(changeinX,changeinY);
}


/*
  Get XY position using the specified method.
  Available methods:
    -0: mouseX and mouseY
    -1: left hand XY position from Kinect using SimpleOpenNI
    -2: right hand XY position from Kinect using SimpleOpenNI
*/
PVector getXYPosition(int method){
  PVector xyPos = new PVector(0,0);
  
  switch (method){
    case 0:
      xyPos = new PVector(mouseX,mouseY);
      break;
    case 1:
      xyPos = getHandXYPos(SimpleOpenNI.SKEL_LEFT_HAND, 0);
      break;
    case 2:
      xyPos = getHandXYPos(SimpleOpenNI.SKEL_RIGHT_HAND, 0);
      break;
  }
  
  return xyPos;
}
