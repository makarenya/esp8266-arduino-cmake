#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>

ESP8266WebServer server(80);

const int led = D0;

void handleRoot() {
    digitalWrite(led, HIGH);
    server.send(200, "text/plain", "hello from esp8266!");
    digitalWrite(led, LOW);
}

void handleNotFound(){
    digitalWrite(led, HIGH);
    String message = "File Not Found\n\n";
    message += "URI: ";
    message += server.uri();
    message += "\nMethod: ";
    message += (server.method() == HTTP_GET)?"GET":"POST";
    message += "\nArguments: ";
    message += server.args();
    message += "\n";
    for (uint8_t i=0; i<server.args(); i++){
        message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
    }
    server.send(404, "text/plain", message);
    digitalWrite(led, LOW);
}

void setup() {
    Serial.begin(9600);
    // wait to attach terminal
    pinMode(led, OUTPUT);
    digitalWrite(led, HIGH);
    delay(4000);
    WiFi.mode(WIFI_STA);
    Serial.print("Trying to connect to ");
    Serial.print(WiFi.SSID());
    WiFi.begin(WiFi.SSID().c_str(),WiFi.psk().c_str());
    while (WiFi.status() == WL_DISCONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    auto status = WiFi.status();
    Serial.print("Status is: ");
    Serial.println(status);
    if (status != WL_CONNECTED) {
        Serial.println("Press router's WPS key");
        delay(1000);
        Serial.println("4...");
        delay(1000);
        Serial.println("3...");
        delay(1000);
        Serial.println("2...");
        delay(1000);
        Serial.println("1...");
        delay(1000);
        Serial.println("Starting WPS");
        if (WiFi.beginWPSConfig()) {
            Serial.print("WPS connected to ");
            Serial.println(WiFi.SSID());
            WiFi.begin(WiFi.SSID().c_str(),WiFi.psk().c_str());
            while (WiFi.status() == WL_DISCONNECTED) {          // last saved credentials
                delay(500);
                Serial.print("."); // show wait for connect to AP
            }
        } else {
            Serial.println("WPS Failed");
        }
    } else {
        Serial.print("already connected to ");
        Serial.println(WiFi.SSID());
    }
    if (MDNS.begin("esp8266")) {
        Serial.println("MDNS responder started");
    }
    digitalWrite(led, LOW);
    server.on("/", handleRoot);
    server.onNotFound(handleNotFound);

    server.begin();
    Serial.println("HTTP server started");
}

void loop() {
    server.handleClient();
}