#!/bin/bash
# before using this script, run this command in the terminal: chmod a+x ./install-opera.sh

#
# @author 	Lucas "Rambotnic" Rafael
# @updated	November 19, 2021
#

# text colors
declare normal="\033[1;37m" # white
declare install="\033[1;33m" # yellow
declare finished="\033[1;32m" # green

echo -e "\n${install}************\n\n Adding Opera repository \n\n************${normal}"
wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'

echo -e "\n${install}************\n\n Installing Opera Stable \n\n************${normal}"
sudo apt-get update
sudo apt-get install opera-stable

echo -e "\n${install}************\n\n Installing h.264 media codecs \n\n************${normal}"
# check to see if CURL is installed, since we need to download the codecs from the web
declare isCurlInstalled=$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")
if [ $isCurlInstalled = 0 ]; then
	echo "CURL was not found. Installing CURL..."
	sudo apt-get install curl
	sleep 2
fi

# get codec from Snap
sudo snap install chromium-ffmpeg
sudo cp /snap/chromium-ffmpeg/23/chromium-ffmpeg-104195/chromium-ffmpeg/libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/ # move codec file to Opera's directory

echo -e "${install}\n*** Removing unused dependencies... ***\n${normal}"
sleep 2
sudo apt autoremove

echo -e "\n${finished}ALL DONE! :)${normal}\n"
read # pause execution
