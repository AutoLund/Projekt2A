
 //Define the pins as the sensor
#define S0 11
#define S1 10
#define S2 5
#define S3 3
#define sensorOut 6

//Define relay pins for color
#define RelayRED 8
#define RelayGREEN 12
#define RelayBLUE 13


//Initialize variables and datatypes
int rfrequency = 0;
int gfrequency = 0;
int bfrequency = 0;
int rfrequency20 = 0;
int gfrequency20 = 0;
int bfrequency20 = 0;


//Create functions for relay activation:
void Red() {
  digitalWrite(RelayGREEN, HIGH);
  digitalWrite(RelayRED, LOW);
  digitalWrite(RelayBLUE, HIGH);
}
void Green() {
  Serial.println("Green");
  digitalWrite(RelayGREEN, LOW);
  digitalWrite(RelayRED, HIGH);
  digitalWrite(RelayBLUE, HIGH);
}
void Blue() {
  Serial.println("Blue");
  digitalWrite(RelayGREEN, HIGH);
  digitalWrite(RelayRED, HIGH);
  digitalWrite(RelayBLUE, LOW); 
}
void Error() {
  digitalWrite(RelayGREEN, HIGH);
  digitalWrite(RelayRED, HIGH);
  digitalWrite(RelayBLUE, HIGH);
}

void setup() {
//
  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  pinMode(S2, OUTPUT);
  pinMode(S3, OUTPUT);
  pinMode(sensorOut, INPUT);

  //Setting relays pins as outputs
  pinMode(RelayRED, OUTPUT);
  pinMode(RelayBLUE, OUTPUT);
  pinMode(RelayGREEN, OUTPUT);

  // Setting frequency-scaling to 100%
  digitalWrite(S0,HIGH);
  digitalWrite(S1,HIGH);

  //Setting Relays to OFF
  //HIGH = OFF / LOW = ON (WTF)
  digitalWrite(RelayRED, HIGH);
  digitalWrite(RelayBLUE, HIGH);
  digitalWrite(RelayGREEN, HIGH);

  Serial.begin(9600);
}


void loop() {
  // Setting red filtered photodiodes to be read
  digitalWrite(S2,LOW);
  digitalWrite(S3,LOW);
  // Reading the output frequency
  rfrequency = pulseIn(sensorOut, LOW);
  //Remaping the value of the frequency to the RGB Model of 0 to 255
  rfrequency = map(rfrequency, 25,72,255,0);
  // Printing the value on the serial monitor
  Serial.print("R= ");//printing name
  Serial.print(rfrequency);//printing RED color frequency
  Serial.print("  ");
  delay(100);

  // Setting Green filtered photodiodes to be read
  digitalWrite(S2,HIGH);
  digitalWrite(S3,HIGH);
  // Reading the output frequency
  gfrequency = pulseIn(sensorOut, LOW);
  //Remaping the value of the frequency to the RGB Model of 0 to 255
  gfrequency = map(gfrequency, 30,90,265,0);
  // Printing the value on the serial monitor
  Serial.print("G= ");//printing name
  Serial.print(gfrequency);//printing RED color frequency
  Serial.print("  ");
  delay(100);

  // Setting Blue filtered photodiodes to be read
  digitalWrite(S2,LOW);
  digitalWrite(S3,HIGH);
  // Reading the output frequency
  bfrequency = pulseIn(sensorOut, LOW);
  //Remaping the value of the frequency to the RGB Model of 0 to 255
  bfrequency = map(bfrequency, 25,70,255,0);
  // Printing the value on the serial monitor
  Serial.print("B= ");//printing name
  Serial.print(bfrequency);//printing RED color frequency
  Serial.println("  ");
  delay(100);

  // Fortolkning af frekvenser


rfrequency20 = rfrequency*1.2;
bfrequency20 = bfrequency*1.1;
gfrequency20 = gfrequency*1.1;


if (bfrequency < 200 && rfrequency < 180 && gfrequency < 200 ) {
  Serial.println("Place element under sensor!");
  Error();
  }

else if(rfrequency > bfrequency && rfrequency > gfrequency){
  Serial.println("red");
  Red();

} 
else if (gfrequency > rfrequency && gfrequency > bfrequency){
  Serial.println("Green");
  Green();
    
}
else if (bfrequency > rfrequency && bfrequency > gfrequency){
  Serial.println("Blue");
  Blue();
}



}