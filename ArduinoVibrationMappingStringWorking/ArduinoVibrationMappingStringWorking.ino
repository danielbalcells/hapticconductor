/*
 * CSIM and SMC 2017
 * 
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/

unsigned long time;
int pins[] = {11,13,10,9,3,6,4,5};
// 4 = grey + orange 
// 5 = broken?? white+brown
//10 = black + green
//3 = white + green
//6 = white + blue
//9 = black + brown
//11 = black + blue
//13 = black + orange
unsigned long vibrateStart = 0;
int vibrationTime = 500;
String readString = "";
boolean pinTest = false;
int counter = 0;


void setup()
{
  Serial.begin(9600);
  for(int i=0; i<8; i++)  pinMode(pins[i], OUTPUT);
  
}


void loop()
{
  if(!pinTest){
  time = millis();
//  string message;

  while (Serial.available()) {
   delay(10);  
   if (Serial.available() >0) {
     char c = Serial.read();  //gets one byte from serial buffer
     readString += c; //makes the string readString
   } 
 }

 if (readString.length() >0) {
    vibrate(readString);
    vibrateStart = time;
    readString = "";
  }

  
//  if(Serial.available()) {
//    message = Serial.read();
////    char charArray[8];
////    message.toCharArray(charArray,8);
////    for (int i =0;i<8;i++){
////      message[i] = mes;
//////      }
////  Serial.println(message[1]);
//    vibrate(message);
//    vibrateStart = time;
////    delay(500);
//  }

  if(time - vibrateStart > vibrationTime){
    stopVibrate();
    }

  } else {
    for(int i = 0;i<8;i++){
    if(i == counter%8){
      analogWrite(pins[i], 0);
      } else {
        analogWrite(pins[i], 0);
        }
    
    }

    counter+=1;
    Serial.println(counter%8);
    delay(500);
    } 
}

void vibrate(String message){
    for(int i = 0; i < 8;i++){

        int messageInt = message[i] - '0';
        if(messageInt != 0){
          analogWrite(pins[i], map(messageInt,1,9,80,255));
          } else {
            analogWrite(pins[i], 0);
            }
        }
  }

void stopVibrate(){
  for(int i =0; i<8;i++){
    analogWrite(pins[i], 0);
    }
    vibrateStart = 0;
  }


