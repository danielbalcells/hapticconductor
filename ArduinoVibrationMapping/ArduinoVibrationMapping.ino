/*
 * CSIM and SMC 2014
 * Stefan Acin, Alan Brame, Daniel Gomez, David Dalmazzo  
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
  time = millis();
  char message[9];
  if(Serial.available()) {
//    char message[9] = Serial.read();
    for (byte i =0;i<9;i++){
      message[i] = Serial.read();
      }
    vibrate(message);
    vibrateStart = time;

  }

  if(time - vibrateStart > vibrationTime){
    stopVibrate();
    }
}

void vibrate(char message[]){
    for(int i = 0; i < 9;i++){

        int messageInt = message[i] - '0';
        if(messageInt != 0){
          analogWrite(pins[i], map(messageInt,1,9,15,255));
          } else {
            analogWrite(pins[i], 0);
            }
        }
  }

void stopVibrate(){
  for(int i =0; i<9;i++){
    analogWrite(pins[i], 0);
    }
    vibrateStart = 0;
  }


