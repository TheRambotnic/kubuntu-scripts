#!/bin/bash

# text colors
declare default="\033[1;0m"
declare yellow="\033[1;33m"
declare cyan="\033[1;36m"
declare green="\033[1;32m"

installPkgs() {
	# essential APT packages
	declare -a essentialsApt=(
		snapd
		gimp
		qalculate-gtk
		wine
		remmina
		audacity
		curl
		easytag
		flameshot
		autokey-qt
		autokey-common
		numlockx
	)

	# update APT
	sudo apt-get update

	for pkg in "${essentialsApt[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${cyan}\n*** ${pkg} is already installed. Skipping... ***\n${default}"
			sleep 2
		else
			echo -e "${yellow}\n=================================="
			echo -e " Installing ${pkg} "
			echo -e "==================================${default}"
			sleep 1
			sudo apt-get install $pkg -y
		fi
	done

	# essential Snap packages
	declare -a essentialsSnap=(
		code
		bitwarden
	)

	for pkg in "${essentialsSnap[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${cyan}\n*** ${pkg} is already installed. Skipping... ***\n${default}"
			sleep 2
		else
			echo -e "${yellow}\n=================================="
			echo -e " Installing ${pkg} "
			echo -e "==================================${default}"
			sleep 1
			sudo snap install --classic $pkg -y
		fi
	done

	installGraphicsDrivers
	removeDependencies
	setup

	echo -e "${green}\nALL DONE! :)\n${default}"
	
	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
}

installGraphicsDrivers() {
	echo -e "${yellow}\n=================================="
	echo -e " Installing graphics drivers... "
	echo -e "==================================${default}"
	sleep 1

	gpuInfo=$(lspci | grep -i vga)

	if [[ $gpuInfo == *"NVIDIA Corporation"* ]]; then
		echo "NVIDIA GPU detected. Installing NVIDIA drivers..."
		sudo add-apt-repository ppa:graphics-drivers/ppa && sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y nvidia-driver-545 libvulkan1 libvulkan1:i386
	elif [[ $gpu_info == *"Advanced Micro Devices"* ]]; then
		echo "AMD GPU detected. Installing AMD drivers..."
		sudo add-apt-repository ppa:kisak/kisak-mesa && sudo dpkg --add-architecture i386 && sudo apt update && sudo apt upgrade && sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386
	else
		echo "No NVIDIA or AMD GPU detected."
	fi
}

removeDependencies() {
	echo -e "${yellow}\n=================================="
	echo -e " REMOVING UNUSED DEPENDENCIES... "
	echo -e "==================================${default}"
	sleep 2
	sudo apt autoremove -y
	sudo apt-get clean
}

setup() {
	echo -e "${yellow}\n=================================="
	echo -e " Setting up a few things... "
	echo -e "==================================${default}"
	sleep 2

	# change Date & Time locale to British English and Numeric/Monetary locales to Brazilian Portuguese
	sudo localectl set-locale LC_TIME=en_GB.UTF8 LC_NUMERIC=pt_BR.UTF8 LC_MONETARY=pt_BR.UTF8

	# set NumLock to be ON
	numlockx on
}

echo -e "\033]2;Install Essentials\007"
echo -e "This file will install essential packages on your computer and you will be prompted for your superuser password in order to do so."
echo -e "NOTE: Please make sure to run this file AFTER 'Remove Bloatware.sh'\n\n"
while true; do
	read -p "Do you wish to continue? [y/n]: " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installPkgs;;
		* ) echo -e "\nPlease select yes (Y) or no (N). ";;
	esac
done
