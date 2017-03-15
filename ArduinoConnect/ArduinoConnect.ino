char val; // Data received from the serial port
int buzzer = 12; //the pin of the active buzzer

void setup() {
   pinMode(buzzer, OUTPUT); // Set pin as OUTPUT
   Serial.begin(9600); // Start serial communication at 9600 bps
 }

void loop() {
   if (Serial.available()) 
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
   }
   if (val == '1') 
   { // If 1 was received
     digitalWrite(buzzer, HIGH); // turn the LED on
   } else {
     digitalWrite(buzzer, LOW); // otherwise turn it off
   }
   delay(10); // Wait 10 milliseconds for next reading
}
