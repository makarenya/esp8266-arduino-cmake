set port=COM4
%localappdata%\Arduino15\packages\esp8266\tools\esptool\0.4.12\esptool.exe -cd nodemcu -cb 921600 -cp %port% -ca 0x00000 -cf cmake-build-release/firmware.bin