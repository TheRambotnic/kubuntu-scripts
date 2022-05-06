#!/bin/bash

# text colors
declare default="\033[1;0m"
declare yellow="\033[1;33m"
declare green="\033[1;32m"

installOpera() {
	echo -e "${yellow}\n=================================="
	echo -e " Adding Opera repository "
	echo -e "==================================${default}"
	sleep 1
	wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
	sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'

	echo -e "${yellow}\n=================================="
	echo -e " Installing Opera Stable "
	echo -e "==================================${default}"
	sleep 1
	sudo apt-get update
	sudo apt-get install opera-stable -y

	echo -e "${yellow}\n=================================="
	echo -e " Installing media codecs "
	echo -e "==================================${default}"
	
	# check to see if Snap Store is installed in order to download the codecs
	declare isSnapInstalled=$(dpkg-query -W -f='${Status}' snapd 2>/dev/null | grep -c "ok installed")
	
	if [ $isSnapInstalled = 0 ]; then
		echo "Snap Store was not found. Installing Snap..."
		sudo apt-get update
		sudo apt-get install snapd -y
		sleep 2
	fi

	# get codec from Snap
	sudo snap install chromium-ffmpeg
	sudo cp /snap/chromium-ffmpeg/current/chromium-ffmpeg-106454/chromium-ffmpeg/libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/ # move codec file to Opera's directory

	removeDependencies

	echo -e "${green}\nALL DONE! :)\n${default}"
	
	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
}

removeDependencies() {
	echo -e "${yellow}\n=================================="
	echo -e " REMOVING UNUSED DEPENDENCIES... "
	echo -e "==================================${default}"
	sleep 2
	sudo apt autoremove -y
	sudo apt-get clean
}

echo -e "\033]2;Install Opera Browser\007"
echo -e "This file will install the Opera Browser on your computer and you will be prompted for your superuser password in order to do so.\n\n"
while true; do
	read -p "Do you wish to continue? [y/n]: " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installOpera;;
		* ) echo -e "\nPlease select yes (Y) or no (N). ";;
	esac
done
