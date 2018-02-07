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

ARDUINO(firmware AccelStepper ESP8266WiFi)
