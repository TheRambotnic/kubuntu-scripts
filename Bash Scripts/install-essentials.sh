#!/bin/bash

#
# @author 	Lucas "Rambotnic" Rafael
# @updated	November 23, 2021
#

# text colors
declare default="\033[1;0m" # default color
declare install="\033[1;33m" # yellow
declare installed="\033[1;36m" # cyan
declare finished="\033[1;32m" # green

installPkgs() {
	# essential packages
	declare -a essentials=(
		snapd
		vlc
		wine
		curl
		gnome-tweaks
		caja
		caja-open-terminal
		mate-terminal
	)

	# update APT
	sudo apt-get update

	for pkg in "${essentials[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${installed}\n*** ${pkg} is already installed. Skipping... ***\n${default}"
			sleep 2
		else
			echo -e "${install}\n==================================\n\n Installing ${pkg} \n\n==================================${default}"
			sleep 1
			sudo apt-get install $pkg
		fi
	done

	echo -e "${install}\n==================================\n\n Configuring package settings... \n\n==================================${normal}"
	# set caja-open-terminal to open with MATE Terminal instead
	sudo gsettings set org.mate.applications-terminal exec mate-terminal

	# set default terminal emulator to MATE Terminal instead
	echo -e "${install}* Ubuntu will now setup the terminal emulator.\n\n* Please select the option with /usr/bin/mate-terminal.wrapper\n${normal}"
	sleep 2
	sudo update-alternatives --config x-terminal-emulator

	echo -e "${install}\n==================================\n\n Removing unused dependencies... \n\n==================================${normal}"
	sleep 2
	sudo apt autoremove
	sudo apt-get clean

	echo -e "\n${finished}ALL DONE! :)${normal}\n"
	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
}

echo -e "This file should be run AFTER remove-bloatware.sh\n\n"
while true; do
	read -p "Do you wish to continue? [y/n] " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installPkgs;;
		* ) echo "Please select yes (Y) or no (N). ";;
	esac
done
