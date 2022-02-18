#!/bin/bash

# text colors
declare default="\033[1;0m"
declare yellow="\033[1;33m"
declare green="\033[1;32m"

# Visual Studio Code
echo -e "${yellow}==================================\n\n Installing Visual Studio Code... \n\n==================================${default}"
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
	echo -e "${yellow}\n==================================\n\n Installing ${pkg} \n\n==================================${default}"
	sleep 2
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

echo -e "\n${green}ALL DONE! :)${default}\n"
read # pause execution
