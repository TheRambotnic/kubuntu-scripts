#!/bin/bash

# text colors
declare yellow="\033[1;33m"
declare default="\033[1;0m"
declare green="\033[1;32m"

echo -e "${yellow}==================================\n\n REMOVING BLOATWARE... \n\n==================================${default}"
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
	echo -e "\n${yellow}****************************"
	echo -e " Uninstalling $pkg"
	echo -e "****************************${default}"
	sudo apt purge $pkg
	sleep 2
done

echo -e "${yellow}\n==================================\n\n REMOVING DEPENDENCIES... \n\n==================================${default}"
sleep 2
sudo apt autoremove
sudo apt-get clean

echo -e "\n${green}ALL DONE! :)${default}\n"
read # pause execution
