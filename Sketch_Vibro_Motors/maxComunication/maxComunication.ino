/*
 * CSIM and SMC 2014
 * Stefan Acin, Alan Brame, Daniel Gomez, David Dalmazzo  
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/

int maxData = 0;
int out_1;
int out_2;
int out_3;
int out_4;
int out_5;
int out_6;
int out_7;
int out_8;

void setup()
{
  Serial.begin(19200);
  pinMode((2,5,8,10,3,6,9,11), OUTPUT);
}

void loop()
{
  while(Serial.available() > 0) {
    maxData = Serial.read();
  }
  if(maxData > 0 && maxData < 30){
    out_1 = map(maxData, 0, 30, 0, 255);
    analogWrite(2, out_1); // turn led on
  }
  else if(maxData > 31 && maxData < 60){
    out_2 = map(maxData, 31, 60, 0, 255);
    analogWrite(5, out_2);
  }
  else if(maxData > 61 && maxData < 90){
    out_3 = map(maxData, 61, 90, 0, 255);
    analogWrite(8, out_3);
  }
  else if(maxData > 91 && maxData < 120){
    out_4 = map(maxData, 91, 120, 0, 255);
    analogWrite(10, out_4);
  }
  else if(maxData > 121 && maxData < 150){
    out_5 = map(maxData, 121, 150, 0, 255);
    analogWrite(3, out_5);
  }
  else if(maxData > 151 && maxData < 180){
    out_6 = map(maxData, 0, 30, 0, 255);
    analogWrite(6, out_6);
  }
  else if(maxData > 181 && maxData < 210){
    out_7 = map(maxData, 181, 210, 0, 255);
    analogWrite(9, out_7);
  }
  else if(maxData > 211 && maxData < 241){
    out_8 = map(maxData, 211, 241, 0, 255);
    analogWrite(11, out_8);
  }
}


