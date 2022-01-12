#!/bin/bash

#
# @author 	Lucas "Rambotnic" Rafael
# @updated	January 11, 2022
#

# text colors
declare default="\033[1;0m" # default color
declare install="\033[1;33m" # yellow
declare finished="\033[1;32m" # green

installOpera() {
	echo -e "${install}\n==================================\n\n Adding Opera repository \n\n==================================${default}"
	sleep 1
	wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
	sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'

	echo -e "${install}\n==================================\n\n Installing Opera Stable \n\n==================================${default}"
	sleep 1
	sudo apt-get update
	sudo apt-get install opera-stable -y

	echo -e "${install}\n==================================\n\n Installing h.264 media codecs \n\n==================================${default}"
	# check to see if Snap Store is installed, since we need to download the codecs from the web
	declare isSnapInstalled=$(dpkg-query -W -f='${Status}' snapd 2>/dev/null | grep -c "ok installed")
	if [ $isSnapInstalled = 0 ]; then
		echo "Snap Store was not found. Installing Snap..."
		sudo apt-get update
		sudo apt-get install snapd -y
		sleep 2
	fi

	# get codec from Snap
	sudo snap install chromium-ffmpeg -y
	sudo cp /snap/chromium-ffmpeg/23/chromium-ffmpeg-104195/chromium-ffmpeg/libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/ # move codec file to Opera's directory

	removeDependencies

	echo -e "\n${finished}ALL DONE! :)${default}\n"
	# pause execution
	read -p "" opt
	case $opt in
		* ) exit;;
	esac
}

removeDependencies() {
	echo -e "${install}\n==================================\n\n Removing unused dependencies... \n\n==================================${default}"
	sleep 2
	sudo apt autoremove -y
	sudo apt-get clean
}

echo -e "This file will install Opera Browser in your computer.\n\n"
while true; do
	read -p "Do you wish to continue? [y/n] " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installOpera;;
		* ) echo "Please select yes (Y) or no (N). ";;
	esac
done
