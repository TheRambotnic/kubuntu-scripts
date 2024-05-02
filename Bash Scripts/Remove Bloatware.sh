#!/bin/bash

# text colors
declare yellow="\033[1;33m"
declare default="\033[1;0m"
declare green="\033[1;32m"

removeSystemBloatware() {
	# bloatware packages
	declare -a sysBloatware=(
		elisa
		kmahjongg
		kmines
		kpat
		ksudoku
		kcalc
		krdc
		konversation
		kde-spectacle
		thunderbird*
		skanlite
	)

	# loop through array and remove packages
	for pkg in "${sysBloatware[@]}"; do
		echo -e "${yellow}\n****************************"
		echo -e " Uninstalling $pkg "
		echo -e "****************************${default}"
		sudo apt purge $pkg -y
		sleep 1
	done
}

removeBloatware() {
	echo -e "${yellow}==============================="
	echo -e " REMOVING BLOATWARE... "
	echo -e "===============================${default}"
	sleep 2

	removeSystemBloatware

	echo -e "${yellow}\n==============================="
	echo -e " REMOVING DEPENDENCIES... "
	echo -e "===============================${default}"
	sleep 2
	sudo apt autoremove -y
	sudo apt-get clean

	echo -e "${green}\nALL DONE! :)\n${default}"

	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
}

echo -e "\033]2;Remove Bloatware\007"
echo -e "This file will remove a few pre-installed packages from your computer and you will be prompted for your superuser password in order to do so.\n\n"

while true; do
	read -p "Do you wish to continue? [y/n]: " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) removeBloatware;;
		* ) echo -e "\nPlease select yes (Y) or no (N). ";;
	esac
done
