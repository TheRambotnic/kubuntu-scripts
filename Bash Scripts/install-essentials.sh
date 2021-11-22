#!/bin/bash
# before using this script, run this command in the terminal: chmod a+x ./install-essentials.sh

#
# @author 	Lucas "Rambotnic" Rafael
# @updated	November 22, 2021
#

# text colors
declare normal="\033[1;37m" # white
declare install="\033[1;33m" # yellow
declare installed="\033[1;36m" # cyan
declare finished="\033[1;32m" # green

installPkgs() {
	# essential packages
	declare -a essentials=(
		vlc
		wine
		curl
		gnome-tweaks
		caja
		caja-open-terminal
		mate-terminal
	)

	for pkg in "${essentials[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${installed}\n*** ${pkg} is already installed. Skipping... ***\n${normal}"
			sleep 2
		else
			echo -e "${install}\n==============================="
			echo -e " Installing ${pkg}"
			echo -e "===============================\n${normal}"
			sleep 1
			sudo apt-get install $pkg
		fi
	done

	echo -e "${install}\n==============================="
	echo -e " Configuring package settings..."
	echo -e "===============================\n${normal}"
	# set caja-open-terminal to open with MATE Terminal instead
	sudo gsettings set org.mate.applications-terminal exec mate-terminal

	# set default terminal emulator to MATE Terminal instead
	echo -e "${install}* Ubuntu will now setup the terminal emulator.\n\n* Please select the option with /usr/bin/mate-terminal.wrapper\n${normal}"
	sleep 2
	sudo update-alternatives --config x-terminal-emulator

	echo -e "${install}\n==============================="
	echo -e " Removing unused dependencies... "
	echo -e "===============================\n${normal}"
	sleep 2
	sudo apt autoremove

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
