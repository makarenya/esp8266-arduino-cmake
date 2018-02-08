# CMake toolset for ESP8266 Arduino builds

A simple way to develop applications for ESP8266 using Arduino libraries, inside any
development environment supporting CMake (created for CLion).

### Currently supported:

Build enrivonment: Arduino 1.6.12  
Toolset: esp8266 by ESP8266 Community version 2.4.0  
OS: Windows (macOS coming soon)

## How to use.

#### Install all components

- Install Arduino
- Open preferences window
- Enter http://arduino.esp8266.com/stable/package_esp8266com_index.json into Additional Board Manager URLs field
- Open Boards Manager from Tools > Board menu and install esp8266 platform.

All toolchains and libraries are installed!

##### Create new CMake Project

Just create CMakeLists.txt with following contents:
```
project(project_name CXX C ASM)
include(cmake/arduino.cmake)
set(USER_SOURCES src/main.cpp)
include_directories(src)
add_executable(elf_name ${USER_SOURCES})
arduino(elf_name AccelStepper ESP8266WiFi)
```

All magic inside the last line of code (and in second, that includes magic). 
The top lines is standard one, you can write it as you want. All you need -
is create any executable, and call arduino macor with executable in as a first
parameter and any used arduino libraries as other parameters. Aaaand. Build it.  
Finish.
