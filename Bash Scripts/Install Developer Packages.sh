#!/bin/bash

# text colors
declare default="\033[1;0m"
declare yellow="\033[1;33m"
declare green="\033[1;32m"

installDevPkgs() {
	# Visual Studio Code
	echo -e "${yellow}=================================="
	echo -e " Installing Visual Studio Code... "
	echo -e "==================================${default}"
	sleep 2

	# check to see if Snap Store is installed
	declare isSnapInstalled=$(dpkg-query -W -f='${Status}' snapd 2>/dev/null | grep -c "ok installed")

	if [ $isSnapInstalled = 0 ]; then
		echo "Snap Store was not found. Installing Snap..."
		sudo apt-get update
		sudo apt-get install snapd -y
		sleep 2
	fi

	sudo snap install --classic code

	# Developer packages
	declare -a devPkgs=(
		git
		npm
	)

	for pkg in "${devPkgs[@]}"; do
		echo -e "${yellow}\n=================================="
		echo -e " Installing ${pkg} "
		echo -e "==================================${default}"
		sleep 1
		sudo apt-get install $pkg -y
	done

	# NodeJS
	sudo npm cache clean -f
	sudo npm install -g n
	sudo n latest

	echo -e "${yellow}\n*** Removing unused dependencies... ***\n${default}"
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

echo -e "\033]2;Install Developer Packages\007"
echo -e "This file will install a few developer packages on your computer and you will be prompted for your superuser password in order to do so.\n\n"
while true; do
	read -p "Do you wish to continue? [y/n]: " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installDevPkgs;;
		* ) echo -e "\nPlease select yes (Y) or no (N). ";;
	esac
done
