/*
 * CSIM and SMC 2014
 * Stefan Acin, Alan Brame, Daniel Gomez, David Dalmazzo  
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/
#include <SoftwareSerial.h>

int testTrigger = 0;
int out_1;
int out_2;
int out_3;
int out_4;
int out_5;
int out_6; //white_blue
int out_7;
int out_8;
unsigned long time;
int pins[] = {4,5,10,3,6,9,11,13};
//int pins[] = {4};
//working: 5,9, 10, 3, 6,11,13,4
//not working: 2, 8
int testpin;

//SoftwareSerial mySerial(0, 1); // RX, TX

void setup()
{
  Serial.begin(9600);
  for(int i=0; i<9; i++)  pinMode(pins[i], OUTPUT);
  testpin = pins[8];
  
}

void loop()
{

  if(Serial.available()) {
     char c = Serial.read();
  
    time = millis();

    if(c == '0'){
      for(int i = 0;i<8;i++){
        analogWrite(pins[i], 255);//white_blue
        }
        
    } else if ( c =='2') {
      for(int i = 0;i<8;i++){
        analogWrite(pins[i], 255);//white_blue
        }
      }
    else {
        for(int i = 0;i<8;i++){
        analogWrite(pins[i], 0);//white_blue
        }
    }
  }    
}


