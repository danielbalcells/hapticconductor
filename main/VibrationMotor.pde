class VibrationMotor {
  PVector position;
  int diameter;
  float vibrationStrength = 1.0;
  float vibrationSpeed = 2.0;
  float yPhase = 1.274;
  boolean vibrating = false;
  color defaultColor = color(255);
  color slowColor = color(0,0,250);
  color fastColor = color(250,0,0);
  int id = 0;
  int vibrateCount = 0;
  int vibrateFrameThreshold = 40;

  VibrationMotor(int x, int y, int dia, int id) {
    position = new PVector(x,y);
    diameter = dia;
    this.id = id;
  }

  void update() {
  }
  
  int getID(){
  return id;
  }

  void display() {
    if(vibrating){
      color intensityColor = lerpColor(slowColor,fastColor,vibrationStrength);
      float xPos = position.x + (float)Math.sin(frameCount*vibrationSpeed)*(vibrationStrength*3);
      float yPos = position.y + (float)Math.sin((frameCount+yPhase)*vibrationSpeed)*(vibrationStrength*3);
      
      fill(intensityColor);
      ellipse(xPos,yPos,diameter+(vibrationStrength*10),diameter+(vibrationStrength*10));
      vibrateCount +=1;
      if (vibrateCount > vibrateFrameThreshold){
        vibrationOff();
      }
    } else {
      fill(defaultColor);
      ellipse(position.x,position.y,diameter,diameter);
    }
  }

  boolean isVibrating() {
    return vibrating;
  }
  
  void setStrength(float strength){
    vibrationStrength = strength;
  }
  
  void setSpeed(float speed){
    vibrationSpeed = speed;
  }

  void toggleVibration() {
    if (vibrating) {
      vibrating = false;
    } else {
      vibrating = true;
    }
  }
  
  void vibrationOn(){
    vibrateCount = 0;
    vibrating = true;
  }
  
  void vibrationOff(){
    vibrating = false;
  }
  
  void setPos(PVector newPos){
    position = newPos;
  }
  
  void setDiameter(int newDiam){
    diameter = newDiam;
  }
}
