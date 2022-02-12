#!/bin/bash

declare default="\033[1;0m"
declare green="\033[1;32m"
declare yellow="\033[1;33m"
declare blue="\033[1;34m"

# list all plugged in devices
adb devices

echo -e "${yellow}Checking if scrcpy is installed...${default}"

declare isScrcpyInstalled=$(dpkg-query -W -f='${Status}' scrcpy 2>/dev/null | grep -c "ok installed")

if [ $isScrcpyInstalled = 1 ]; then
	echo -e "${green}scrcpy is already installed.${default}"
	sleep 1
else
	echo "${yellow}scrcpy was not found. Installing...${default}"
	sleep 1
	sudo apt-get install scrcpy -y
fi

echo -e "${blue}\nRunning scrcpy...\nSource Code: https://github.com/Genymobile/scrcpy \n${default}"
scrcpy
