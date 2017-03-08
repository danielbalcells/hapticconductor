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

  VibrationMotor(int x, int y, int dia) {
    position = new PVector(x,y);
    diameter = dia;
  }

  void update() {
  }

  void display() {
    if(vibrating){
      color intensityColor = lerpColor(slowColor,fastColor,vibrationStrength);
      float xPos = position.x + (float)Math.sin(frameCount*vibrationSpeed)*(vibrationStrength*3);
      float yPos = position.y + (float)Math.sin((frameCount+yPhase)*vibrationSpeed)*(vibrationStrength*3);
      
      fill(intensityColor);
      ellipse(xPos,yPos,diameter+(vibrationStrength*10),diameter+(vibrationStrength*10));

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
    vibrating = true;
  }
  
  void vibrationOff(){
    vibrating = false;
  }
}