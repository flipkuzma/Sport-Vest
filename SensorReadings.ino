#include <DHT11.h>
#include <Adafruit_Sensor.h>


int analogPinUV  = A0; // UV SENSOR PIN
float uvValue = 0.00;
int analogPinFSR = A1; // FSR SENSOR PIN
int fsrValue = 0;

DHT11 dht11(2);


void setup() {
  Serial.begin(115200);


  pinMode(12, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
}

void loop() {
  int temperature = 0;
  int humidity = 0;

  // Read UV and FSR sensor values
  uvValue = analogRead(analogPinUV);
  fsrValue = analogRead(analogPinFSR);

  // Read temperature and humidity
  int result = dht11.readTemperatureHumidity(temperature, humidity);
  int tempF = round((temperature * 9 / 5) + 32);

  // Print all sensor data
  Serial.print(round(uvValue / 0.1));  
  Serial.print(",");
  Serial.print(fsrValue);
  Serial.print(",");
  Serial.print(tempF);
  Serial.print(",");
  Serial.print(humidity);
  Serial.print(",");
  Serial.print(analogRead(A3));
  Serial.println();

  delay(20);
}
