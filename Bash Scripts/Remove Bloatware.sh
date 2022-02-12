#!/bin/bash

#
# @author	Lucas "Rambotnic" Rafael
# @updated	November 23, 2021
#

# text colors
declare warning="\033[1;33m" # yellow
declare default="\033[1;0m" # default color
declare finished="\033[1;32m" # green

echo -e "${warning}==================================\n\n REMOVING BLOATWARE... \n\n==================================${default}"
sleep 3

# bloatware packages
declare -a bloatware=(
	firefox*
	thunderbird*
	rhythmbox
	celluloid
	shotwell
	aisleriot
	gnome-todo
	gnome-sudoku
	gnome-mines
	gnome-mahjongg
	gnome-bluetooth
	simple-scan
	seahorse
	transmission*
	file-roller
	totem*
	deja-dup*
	ibus*
)

# loop through array and remove packages
for pkg in "${bloatware[@]}"; do
	echo -e "\n${warning}****************************"
	echo -e " Uninstalling $pkg"
	echo -e "****************************${default}"
	sudo apt purge $pkg
	sleep 2
done

echo -e "${warning}\n==================================\n\n REMOVING DEPENDENCIES... \n\n==================================${default}"
sleep 2
sudo apt autoremove
sudo apt-get clean

echo -e "\n${finished}ALL DONE! :)${default}\n"
read # pause execution
