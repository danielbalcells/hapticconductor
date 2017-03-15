  // Example by Tom Igoe

  import processing.serial.*;
  Serial myPort;
void setup() {

  // List all the available serial ports:
  printArray(Serial.list());

  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[3], 19200);

  // Send a capital "A" out the serial port
  frameRate(5);
  
   myPort.write('A');
}


void draw(){
  
}

void mousePressed(){
   myPort.write('0');
}

void mouseReleased(){
   myPort.write('1');
}