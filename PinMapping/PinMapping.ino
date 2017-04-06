/*
 * CSIM and SMC 2017
 * 
 * Advanced Interface Design
 * Universitat Pompeu Fabra 
*/

unsigned long time;
//int pins[] = {4,5,10,3,6,9,11,13};
int pins[] = {11,13,10,9,3,6,4,5};
// 4 = grey + orange 
// 5 = broken?? white+brown
//10 = black + green
//3 = white + green
//6 = white + blue
//9 = black + brown
//11 = black + blue
//13 = black + orange

//4 5 7 
unsigned long vibrateStart = 0;
int vibrationTime = 500;
String readString = "";
int counter = 0;


void setup()
{
  Serial.begin(9600);
  for(int i=0; i<8; i++)  pinMode(pins[i], OUTPUT);
  //analogWrite(pins[i], 0);
}


void loop()
{
  for(int i = 0;i<9;i++){
    if(i == counter%9){
      analogWrite(pins[i], 0);
      } else {
        analogWrite(pins[i], 0);
        }
    
    }
//
//
////    for(int i = 1;i<30;i++){
////    if(i == counter%30){
////      analogWrite(i, 255);
////      } else {
////        analogWrite(i, 0);
////        }
////    
////    }
//
  counter+=1;
  Serial.println(counter%8);
//int index = 1;
//analogWrite(4, 0);
delay(500);
//analogWrite(pins[index], 0);
}
