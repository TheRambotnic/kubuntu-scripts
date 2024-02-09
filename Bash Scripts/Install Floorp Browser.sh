#!/bin/bash

installFloorp() {
    curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
    sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
    sudo apt update
    sudo apt install floorp
}

echo -e "\033]2;Install Floorp Browser\007"
echo -e "This file will install the Floorp Browser on your computer and you will be prompted for your superuser password in order to do so."
echo -e "NOTE: Please make sure to run this file AFTER 'Install Essentials.sh'\n\n"
while true; do
	read -p "Do you wish to continue? [y/n]: " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installFloorp;;
		* ) echo -e "\nPlease select yes (Y) or no (N). ";;
	esac
done
