/*
  Initialises motor objects
*/

void initMotors(String mode, int size){
  motors = new ArrayList<VibrationMotor>();
  for (int i = 0;i < size;i++){
    if (mode == "line"){
      motors.add(new VibrationMotor(((width/size)/2)+(i*(width/size)),height/2,50,i));
    } else if (mode == "circle") {
      float posx = width/2+200*sin(TWO_PI/float(size)*i);
      float posy = height/2+200*cos(TWO_PI/float(size)*i);
      motors.add(new VibrationMotor(int(posx),int(posy),50,i));
      //for(int i=0;i<5;i++)
//{
  //float posx=150*sin(TWO_PI/5.0*i);
  //float posy=150*cos(TWO_PI/5.0*i);
  //draw object number i
//} 

  //
    }
  }

  
  
}