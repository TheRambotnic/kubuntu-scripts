#!/bin/bash

# Text colors
declare CLR_DEFAULT="\033[1;0m"
declare CLR_YELLOW="\033[1;33m"
declare CLR_CYAN="\033[1;36m"
declare CLR_GREEN="\033[1;32m"

installPkgs() {
	# Install Nala (APT frontend replacement)
	curl https://gitlab.com/volian/volian-archive/-/raw/main/install-nala.sh | bash

	# Setup repositories
	sudo add-apt-repository ppa:zhangsongcui3371/fastfetch

	sudo nala update

	# Essential packages
	declare -a essentialsApt=(
		gimp
		qalculate-gtk
		wine
		remmina
		audacity
		curl
		easytag
		flameshot
		autokey-qt
		numlockx
		fastfetch
		zsh
		htop
		qdirstat
	)

	for pkg in "${essentialsApt[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${CLR_CYAN}\n*** ${pkg} is already installed. Skipping... ***\n${CLR_DEFAULT}"
			sleep 1
		else
			displayInstallMessage $pkg
			sudo nala install $pkg -y
			sleep 1
		fi
	done

	# Essential Snap packages (stay away from these in the future...)
	declare -a essentialsSnap=(
		code
		bitwarden
	)

	for pkg in "${essentialsSnap[@]}"; do
		declare isPkgInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed")

		if [ $isPkgInstalled = 1 ]; then
			echo -e "${CLR_CYAN}\n*** ${pkg} is already installed. Skipping... ***\n${CLR_DEFAULT}"
			sleep 1
		else
			displayInstallMessage $pkg
			sudo snap install --classic $pkg
			sleep 1
		fi
	done

	# Neovim
	displayInstallMessage "neovim"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

	if [ ! -d ~/.config/nvim/ ]; then
		mkdir ~/.config/nvim/
	fi

	mv "../Shell Configs/init.lua" ~/.config/nvim/

	sleep 1

	installGraphicsDrivers
	removeDependencies
	setup

	echo -e "${CLR_GREEN}\nALL DONE! :)\n${CLR_DEFAULT}"
	echo "Some settings require a session restart to take effect."
	
	while true; do
		read -p "Would you like to restart your session now? (You can do this later if you want) [y/n]: " yn
		case $yn in
			[Nn]* ) exit;;
			[Yy]* ) sudo pkill -KILL -u $(whoami);;
			* ) echo -e "\nPlease select yes (Y) or no (N). ";;
		esac
	done
}

installGraphicsDrivers() {
	displayInstallMessage "graphics drivers"
	sleep 1

	gpuInfo=$(lspci | grep -i vga)

	if [[ $gpuInfo == *"NVIDIA Corporation"* ]]; then
		echo "NVIDIA GPU detected. Installing NVIDIA drivers..."
		sudo add-apt-repository ppa:graphics-drivers/ppa && sudo dpkg --add-architecture i386 && sudo nala update && sudo nala install -y nvidia-driver-555 libvulkan1 libvulkan1:i386
	elif [[ $gpu_info == *"Advanced Micro Devices"* ]]; then
		echo "AMD GPU detected. Installing AMD drivers..."
		sudo add-apt-repository ppa:kisak/kisak-mesa && sudo dpkg --add-architecture i386 && sudo nala update && sudo nala upgrade && sudo nala install -y libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386
	else
		echo "No NVIDIA or AMD GPU detected."
	fi
}

removeDependencies() {
	echo -e "${CLR_YELLOW}"
	echo -e "=================================="
	echo -e " REMOVING UNUSED DEPENDENCIES...  "
	echo -e "=================================="
	echo -e "${CLR_DEFAULT}"
	sleep 1
	sudo nala autoremove -y && sudo nala clean
}

setup() {
	echo -e "${CLR_YELLOW}\n=================================="
	echo -e " Setting up a few things... "
	echo -e "==================================${CLR_DEFAULT}"
	sleep 1

	# Change Date & Time locale to British English and Numeric/Monetary locales to Brazilian Portuguese
	sudo localectl set-locale LC_TIME=en_GB.UTF8 LC_NUMERIC=pt_BR.UTF8 LC_MONETARY=pt_BR.UTF8

	# Set NumLock to be ON
	numlockx on

	# Move custom .zshrc file to the correct directory
	mv "../Shell Configs/zshrc" ~/.zshrc

	# Set zsh to be the default shell
	declare USERNAME=$(whoami)
	sudo sed -i -e "s|root:/bin/bash|root:/usr/bin/zsh|g" -e "s|$USERNAME:/bin/bash|$USERNAME:/usr/bin/zsh|g" /etc/passwd
}

displayInstallMessage() {
	echo -e "${CLR_YELLOW}"
	echo -e "\n=================================="
	echo -e " Installing $1 "
	echo -e "=================================="
	echo -e "${CLR_DEFAULT}"
}

# Entry point
echo -e "\033]2;Install Essentials\007"

echo -e "This file will install essential packages on your computer and you will be prompted for your superuser password in order to do so."
echo -e "NOTE: Please make sure to run this file AFTER 'Remove Bloatware.sh'\n\n"
while true; do
	read -p "Do you wish to continue? [y/n]: " yn
	case $yn in
		[Nn]* ) exit;;
		[Yy]* ) installPkgs;;
		* ) echo -e "\nPlease select yes (Y) or no (N). ";;
	esac
done
