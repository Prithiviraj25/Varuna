#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

// Define Firebase credentials
#define FIREBASE_HOST "https://esp32-bb174-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define FIREBASE_AUTH "NYYMrbUPqKX3J7ATcSxJqf8sGft2"

// Pin assignments
#define TEMPERATURE_PIN A0
#define PH_SENSOR_PIN A1  // Simulated pH sensor using a potentiometer
#define NITRATE_SENSOR_PIN A2  // Simulated Nitrate sensor using a potentiometer
#define TSS_SENSOR_PIN A3  // Simulated TSS sensor using a potentiometer
#define UV_SENSOR_PIN A4  // Simulated UV sensor using a potentiometer
#define DO_SENSOR_PIN A5  // Simulated DO sensor using a potentiometer

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin("Rohan", "teju1234");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  // Read temperature from the sensor (simulated)
  int temperatureValue = analogRead(TEMPERATURE_PIN);
  float temperature = map(temperatureValue, 0, 1023, 0, 100);  // Simulated temperature mapping

  // Read pH from the simulated pH sensor
  int pHValue = analogRead(PH_SENSOR_PIN);
  float pH = map(pHValue, 0, 1023, 0, 14);  // Simulated pH mapping

  // Read Nitrate from the simulated Nitrate sensor
  int nitrateValue = analogRead(NITRATE_SENSOR_PIN);
  float nitrate = map(nitrateValue, 0, 1023, 0, 100);  // Simulated Nitrate mapping

  // Read TSS from the simulated TSS sensor
  int tssValue = analogRead(TSS_SENSOR_PIN);
  float tss = map(tssValue, 0, 1023, 0, 100);  // Simulated TSS mapping

  // Read UV intensity from the simulated UV sensor
  int uvValue = analogRead(UV_SENSOR_PIN);
  float uvIntensity = map(uvValue, 0, 1023, 0, 100);  // Simulated UV mapping

  // Read Dissolved Oxygen (DO) from the simulated DO sensor
  int doValue = analogRead(DO_SENSOR_PIN);
  float dissolvedOxygen = map(doValue, 0, 1023, 0, 20);  // Simulated DO mapping

  // Print sensor values to Serial Monitor
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print("°C, pH: ");
  Serial.print(pH);
  Serial.print(", Nitrate: ");
  Serial.print(nitrate);
  Serial.print(", TSS: ");
  Serial.print(tss);
  Serial.print(", UV Intensity: ");
  Serial.print(uvIntensity);
  Serial.print(", Dissolved Oxygen: ");
  Serial.println(dissolvedOxygen);

  // Upload sensor values to Firebase
  Firebase.setFloat("temperature", temperature);
  Firebase.setFloat("pH", pH);
  Firebase.setFloat("nitrate", nitrate);
  Firebase.setFloat("TSS", tss);
  Firebase.setFloat("UV_intensity", uvIntensity);
  Firebase.setFloat("dissolvedOxygen", dissolvedOxygen);

  delay(5000); // Delay for 5 seconds
}
