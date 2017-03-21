/*
 * CSIM and SMC 2017
 * 
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/

unsigned long time;
int pins[] = {4,5,10,3,6,9,11,13};
unsigned long vibrateStart = 0;
int vibrationTime = 125;
boolean simplified = true;


void setup()
{
  Serial.begin(9600);
  for(int i=0; i<8; i++)  pinMode(pins[i], OUTPUT);
  
}


void loop()
{
  time = millis();
  char* message;
  if(Serial.available()) {
    message = Serial.read();
//    for (byte i =0;i<8;i++){
//      message[i] = Serial.read();
//      }
    vibrate(message);
    vibrateStart = time;

  }

  if(time - vibrateStart > vibrationTime){
    stopVibrate();
    }
}

void vibrate(char* message){
  if(simplified){
    for(int i =0; i<8;i++){
      analogWrite(pins[i], 255);
    }
    
    } else {
      for(int i = 0; i < 8;i++){

        int messageInt = message[i] - '0';
        if(messageInt != 0){
          analogWrite(pins[i], map(messageInt,1,9,15,255));
          } else {
            analogWrite(pins[i], 0);
            }
        }
      }
    
  }

void stopVibrate(){
  for(int i =0; i<8;i++){
    analogWrite(pins[i], 0);
    }
    vibrateStart = 0;
  }


