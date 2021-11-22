#!/bin/bash
# before using this script, run this command in the terminal: chmod a+x ./remove-bloatware.sh

#
# @author	Lucas "Rambotnic" Rafael
# @updated	November 20, 2021
#

# text colors
declare warning="\033[1;33m" # yellow
declare regular="\033[1;37m" # white
declare finished="\033[1;32m" # green

echo -e "${warning}========================="
echo -e "| REMOVING BLOATWARE... |"
echo -e "=========================${regular}"
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
	echo -e "****************************${regular}"
	sudo apt purge $pkg
	sleep 2
done

echo -e "\n${warning}============================"
echo -e "| REMOVING DEPENDENCIES... |"
echo -e "============================${regular}"
sleep 2
sudo apt autoremove

echo -e "\n${finished}ALL DONE! :)${regular}\n"
read # pause execution
