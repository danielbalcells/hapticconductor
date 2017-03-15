/*
 * CSIM and SMC 2014
 * Stefan Acin, Alan Brame, Daniel Gomez, David Dalmazzo  
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/

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
int pins[] = {2,5,8,10,3,6,9,11,13};


void setup()
{
  Serial.begin(19200);
  for(int i=0; i<9; i++)  pinMode(pins[i], OUTPUT);
  
}


void loop()
{

  if(Serial.available()) {
     char c = Serial.read();
  
    time = millis();

    if(c == '0'){
        analogWrite(13, 255);//white_blue
    }
    else {
        analogWrite(13, 0);//black_brown
    }
  }    
}


