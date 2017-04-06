  import processing.serial.*;
  Serial myPort;
  
  void initSerial(){
  // List all the available serial ports:
  printArray(Serial.list());

  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[5], 9600);
  }
  
  void sendBlip(){
    String message = "";
    for( VibrationMotor m: motors) {
      if(m.isVibrating()){
        message += new Integer((int)map(m.strength(),0.0,1.0,1.0,9.0)).toString();
      }
      else{
        message += '0';
      }
    }
    //println(message);
    myPort.write(message);
  }
