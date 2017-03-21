  // Example by Tom Igoe

  import processing.serial.*;
  Serial myPort;
void setup() {

  // List all the available serial ports:
  printArray(Serial.list());

  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[7], 9600);

  // Send a capital "A" out the serial port
  frameRate(5);
  
   myPort.write('A');
}


void draw(){
  
}

void mousePressed(){
  if(mouseButton==1) {
    myPort.write('0');
  } else {
  myPort.write('2');
  }
   
}

void mouseReleased(){
   myPort.write('1');
}