  // Example by Tom Igoe

  import processing.serial.*;
  Serial myPort;
void setup() {

  // List all the available serial ports:
  printArray(Serial.list());

  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);

  // Send a capital "A" out the serial port
  
}


void draw(){
  if(mousePressed) {
    myPort.write(1);
  } else {
    myPort.write(0);
  }
}

