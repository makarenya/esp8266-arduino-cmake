cmake_minimum_required(VERSION 3.6)
project(node CXX C ASM)

include(cmake/arduino.cmake)

set(USER_SOURCES
    src/main.cpp
)

include_directories(
    src
)


add_executable(firmware ${USER_SOURCES})

ARDUINO(firmware ESP8266WiFi ESP8266WebServer ESP8266mDNS)
