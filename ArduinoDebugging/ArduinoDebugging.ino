/*
 * CSIM and SMC 2017
 * 
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/

unsigned long time;
int pins[] = {2,5,8,10,3,6,9,11,13};
unsigned long vibrateStart = 0;
int vibrationTime = 500;


void setup()
{
  Serial.begin(19200);
  for(int i=0; i<9; i++)  pinMode(pins[i], OUTPUT);
  
}


void loop()
{

  if(Serial.available()) {


  }


}


