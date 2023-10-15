#!/bin/bash

# text colors
declare default="\033[1;0m"
declare yellow="\033[1;33m"
declare cyan="\033[1;36m"
declare green="\033[1;32m"

installPkgs() {
	# essential packages
	declare -a essentials=(
		snapd
		gimp
		gnome-keyring
		qalculate-gtk
	)
	
	# Include these if you want to:
	# 	wine
	# 	curl
	# 	easytag
	# 	audacity

	# update APT
	sudo apt-get update

	for pkg in "${essentials[@]}"; do
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

	removeDependencies
	setup

	echo -e "${green}\nALL DONE! :)\n${default}"
	
	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
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

	# change Date & Time locale to English and Numeric/Monetary locales to Brazilian Portuguese
	sudo localectl set-locale LC_TIME=en_US.UTF8 LC_NUMERIC=pt_BR.UTF8 LC_MONETARY=pt_BR.UTF8
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
