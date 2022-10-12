#!/bin/bash

# text colors
declare default="\033[1;0m"
declare green="\033[1;32m"
declare yellow="\033[1;33m"
declare blue="\033[1;34m"

echo -e "${yellow}Checking if required packages are installed...\n${default}"
sleep 1

declare -a pkgs=(
	adb
	scrcpy
)

for pkg in "${pkgs[@]}"; do
	declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

	if [ $isPkgInstalled = 1 ]; then
		echo -e "${green}$pkg is already installed.${default}"
		sleep 1
	else
		echo -e "${yellow}$pkg was not found. Installing...${default}"
		sleep 1
		sudo apt-get install $pkg -y
	fi
done

# list all plugged in devices
adb devices

echo -e "${blue}\nRunning scrcpy...\nSource Code: https://github.com/Genymobile/scrcpy \n${default}"
scrcpy
