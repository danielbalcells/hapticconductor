/*
  Runs during setup.
  Initializes Kinect object with the right settings.
*/
void initKinect(){
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth();
  // turn on user tracking
  kinect.enableUser();
  // Turn on RGB image acquisition
  kinect.enableRGB(IMG_WIDTH,IMG_HEIGHT, KINECT_FPS); 
}

/*
  Tracks a hand and returns its XY position
*/
PVector getJointXYPos(int jointToTrack, int drawDepthImage){
  PVector handPos = new PVector(0,0);
  
  if(drawDepthImage == 1){
    PImage depth = kinect.depthImage();
    image(depth, 0, 0);
  }
  
  // make a vector of ints to store the list of users
  IntVector userList = new IntVector();
  // write the list of detected users
  // into our vector
  kinect.getUsers(userList);
  // if we found any users
  if (userList.size() > 0) {
    // get the first user
    int userId = userList.get(0);
    // if we’re successfully calibrated
    if ( kinect.isTrackingSkeleton(userId)) {
      // make a vector to store the  hand
      PVector hand = new PVector();
      // put the position of the hand into that vector
      float confidence = kinect.getJointPositionSkeleton(userId, 
                            jointToTrack, 
                            hand);
      // convert the detected hand position
      // to "projective" coordinates
      // that will match the depth image
      PVector convertedHand = new PVector();
      kinect.convertRealWorldToProjective(hand, convertedHand);
      // and display it
      if(drawDepthImage == 1){
        fill(255, 0, 0);
        ellipse(convertedHand.x, convertedHand.y, 10, 10);
      }
      handPos = convertedHand;
    }
  }
  return handPos;
}

// Tracking functions
void onNewUser(SimpleOpenNI curContext, int userId)
{
  if(DEBUG_FLAG == 1){
    println("onNewUser - userId: " + userId);
    println("\tstart tracking skeleton");
  }
  kinect.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  if(DEBUG_FLAG ==1){
    println("onLostUser - userId: " + userId);
  }
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  if (DEBUG_FLAG == 1){
    println("onVisibleUser - userId: " + userId);
  }
}
