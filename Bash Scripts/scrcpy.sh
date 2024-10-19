#!/bin/bash

# text colors
declare CLR_DEFAULT="\033[1;0m"
declare CLR_GREEN="\033[1;32m"
declare CLR_YELLOW="\033[1;33m"
declare CLR_BLUE="\033[1;34m"

installPkgs() {
	echo -e "${CLR_YELLOW}"
	echo -e "Checking if required packages are installed...\n"
	echo -e "${CLR_DEFAULT}"
	sleep 1

	declare -a pkgs=(
		ffmpeg
		libsdl2-2.0-0
		adb
		wget
		gcc
		git
		pkg-config
		meson
		ninja-build
		libsdl2-dev
		libavcodec-dev
		libavdevice-dev
		libavformat-dev
		libavutil-dev
		libswresample-dev
		libusb-1.0-0
		libusb-1.0-0-dev
	)

	sudo apt-get update

	for pkg in "${pkgs[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${CLR_GREEN}$pkg is already installed.${CLR_DEFAULT}"
		else
			echo -e "${CLR_YELLOW}Installing $pkg...${CLR_DEFAULT}"
			sudo apt install $pkg -y
			sleep 1
		fi
	done
}

checkInstallation() {
	# Check to see if scrcpy is already installed
	cd ~/

	if [ -d ".scrcpy" ]; then
		echo -e "${CLR_YELLOW}scrcpy is already installed. Updating...${CLR_DEFAULT}"

		cd .scrcpy/

		git pull
		./install_release.sh
	else
		echo -e "${CLR_YELLOW}Installing scrcpy...${CLR_DEFAULT}"
		installScrcpy
	fi
}

installScrcpy() {
	git clone https://github.com/Genymobile/scrcpy .scrcpy
	cd .scrcpy

	./install_release.sh
}

runScrcpy() {
	installPkgs
	checkInstallation
	scrcpy
}

# Entry point
echo -e "${CLR_BLUE}Running scrcpy (Android screen mirroring)${CLR_DEFAULT}"
echo "Source Code: https://github.com/Genymobile/scrcpy"
sleep 1

runScrcpy
