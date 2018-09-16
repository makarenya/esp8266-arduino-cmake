# .o extension is important, so this 2 lines appends new system esp8266 this it's own configuration file esp8266.cmake
set(CMAKE_SYSTEM_NAME ESP8266)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/Modules")

# esp8266 compiler triplet name
set(TARGET_TRIPLET xtensa-lx106-elf)
# flash size
set(FLASH_SIZE 4m)
# system magic, detect arduino dir and system extension
if(CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin")
    set(USER_HOME $ENV{HOME})
    set(SYSTEM_EXTENSION "")
    set(ARDUINO_DIR "${USER_HOME}/Library/Arduino15")
    set(SYSTEM_LIBRARIES_ROOT /Applications/Arduino.app/Contents/Java/libraries)
    set(USER_LIBRARIES_ROOT "${USER_HOME}/Documents/Arduino/libraries")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
    if(NOT DEFINED RAW_USER_HOME)
        set(RAW_USER_HOME $ENV{USERPROFILE})
    endif()
    string(REPLACE "\\" "/" USER_HOME ${RAW_USER_HOME})
    set(SYSTEM_EXTENSION ".exe")
    set(RAW_ARDUINO_DIR "$ENV{LOCALAPPDATA}/Arduino15")
    string(REPLACE "\\" "/" ARDUINO_DIR ${RAW_ARDUINO_DIR})
    set(RAW_SYSTEM_LIBRARIES_ROOT "$ENV{PROGRAMFILES}/Arduino/libraries")
    string(REPLACE "\\" "/" SYSTEM_LIBRARIES_ROOT ${RAW_SYSTEM_LIBRARIES_ROOT})
    set(USER_LIBRARIES_ROOT "${USER_HOME}/Documents/Arduino/libraries")
else()
    message(FATAL_ERROR Unsupported build platform.)
endif()

# only esp8266 package inside arduino is interesing
set(ARDUINO_ESP8266_HOME ${ARDUINO_DIR}/packages/esp8266)

# find toolchain bin directory
file(GLOB TOOLCHAIN_SUBDIRS LIST_DIRECTORIES=TRUE "${ARDUINO_ESP8266_HOME}/tools/xtensa-lx106-elf-gcc/*")
list(GET TOOLCHAIN_SUBDIRS 0 TOOLCHAIN_ROOT)
set(TOOLCHAIN_BIN ${TOOLCHAIN_ROOT}/bin)

# find hardware root directory
file(GLOB HARDWARE_SUBDIRS LIST_DIRECTORIES=TRUE "${ARDUINO_ESP8266_HOME}/hardware/esp8266/*")
list(GET HARDWARE_SUBDIRS 0 HARDWARE_ROOT)
set(ESP8266_LIBRARIES_ROOT ${HARDWARE_ROOT}/libraries)

# esptool location
file(GLOB ESPTOOL_SUBDIRS LIST_DIRECTORIES=TRUE "${ARDUINO_ESP8266_HOME}/tools/esptool/*")
list(GET ESPTOOL_SUBDIRS 0 ESPTOOL_DIR)
set(ESPTOOL_APP ${ESPTOOL_DIR}/esptool${SYSTEM_EXTENSION})



link_directories(
    ${HARDWARE_ROOT}/tools/sdk/lib
    ${HARDWARE_ROOT}/tools/sdk/ld
    ${HARDWARE_ROOT}/tools/sdk/libc/xtensa-lx106-elf/lib
)

#setup flags
set(COMMON_FLAGS "-w -g -Os -mlongcalls -ffunction-sections -fdata-sections -MMD -mtext-section-literals -falign-functions=4")
set(CMAKE_CXX_FLAGS "-fno-exceptions -fno-rtti -std=c++11 ${COMMON_FLAGS}")
set(CMAKE_C_FLAGS "-Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib ${COMMON_FLAGS} -std=gnu99")
set(CMAKE_ASM_FLAGS "-x assembler-with-cpp ${COMMON_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS
        "-nostdlib -Wl,--no-check-sections -u call_user_start -u _printf_float -u _scanf_float -Wl,-static -Teagle.flash.${FLASH_SIZE}.ld -Wl,--gc-sections -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read")

# set compilers
set(CMAKE_C_COMPILER "${TOOLCHAIN_BIN}/${TARGET_TRIPLET}-gcc${SYSTEM_EXTENSION}")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_BIN}/${TARGET_TRIPLET}-g++${SYSTEM_EXTENSION}")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_BIN}/${TARGET_TRIPLET}-gcc${SYSTEM_EXTENSION}")

# supress compiler checking
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_ASM_COMPILER_WORKS 1)

# supress determining compiler id
set(CMAKE_C_COMPILER_ID_RUN 1)
set(CMAKE_CXX_COMPILER_ID_RUN 1)
set(CMAKE_ASM_COMPILER_ID_RUN 1)

# CMAKE_C_COMPILER is not mistake, gcc for all, not g++
set(CMAKE_CXX_LINK_EXECUTABLE
        "<CMAKE_C_COMPILER> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")

set(CMAKE_C_LINK_EXECUTABLE
        "<CMAKE_C_COMPILER> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
