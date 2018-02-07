#include <Arduino.h>

void setup() {
    Serial.begin(9600);
}

void loop() {
    Serial.println("time");
    delay(1000);
}