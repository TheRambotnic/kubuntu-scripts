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
		vlc
		wine
		curl
		easytag
		audacity
		gimp
		remmina
	)

	# update APT
	sudo apt-get update

	for pkg in "${essentials[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${cyan}\n*** ${pkg} is already installed. Skipping... ***\n${default}"
			sleep 2
		else
			echo -e "${yellow}\n==================================\n\n Installing ${pkg} \n\n==================================${default}"
			sleep 1
			sudo apt-get install $pkg -y
		fi
	done

	removeDependencies

	echo -e "\n${green}ALL DONE! :)${default}\n"
	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
}

removeDependencies() {
	echo -e "${yellow}\n==================================\n\n Removing unused dependencies... \n\n==================================${default}"
	sleep 2
	sudo apt autoremove -y
	sudo apt-get clean
}

echo -e "This file should be run AFTER 'Remove Bloatware.sh'\n\n"
while true; do
	read -p "Do you wish to continue? [y/n] " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installPkgs;;
		* ) echo "Please select yes (Y) or no (N). ";;
	esac
done
