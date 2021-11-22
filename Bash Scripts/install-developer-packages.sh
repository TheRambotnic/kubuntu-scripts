#!/bin/bash
# before using this script, run this command in the terminal: chmod a+x ./install-developer-packages.sh

#
# @author 	Lucas "Rambotnic" Rafael
# @updated	November 20, 2021
#

# text colors
declare normal="\033[1;37m" # white
declare install="\033[1;33m" # yellow
declare finished="\033[1;32m" # green

# Visual Studio Code
echo -e "${install}==============================="
echo -e " Installing Visual Studio Code..."
echo -e "===============================${normal}"
sleep 2
sudo snap install --classic code

# Developer packages
declare -a devPkgs=(
	git
	npm
)

for pkg in "${devPkgs[@]}"; do
	echo -e "${install}\n==============================="
	echo -e " Installing ${pkg}"
	echo -e "===============================\n${normal}"
	sleep 2
	sudo apt-get install $pkg
done

# NodeJS
sudo npm cache clean -f
sudo npm install -g n
sudo n latest

echo -e "${install}\n*** Removing unused dependencies... ***\n${normal}"
sleep 2
sudo apt autoremove

echo -e "\n${finished}ALL DONE! :)${normal}\n"
read # pause execution
