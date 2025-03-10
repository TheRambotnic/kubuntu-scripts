#!/bin/bash

# Text colors
declare CLR_DEFAULT="\033[1;0m"
declare CLR_YELLOW="\033[1;33m"
declare CLR_CYAN="\033[1;36m"
declare CLR_GREEN="\033[1;32m"

installPkgs() {
	displayInstallMessage "curl"
	sudo apt install curl

	curlDownloads
	gitDownloads
	setupRepositories

	sudo nala update

	# Essential packages
	declare -a essentialsApt=(
		firefox
		gimp
		qalculate-gtk
		wine
		remmina
		audacity
		easytag
		flameshot
		autokey-qt
		fastfetch
		zsh
		htop
		qdirstat
        mangohud
        goverlay
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

		sudo add-apt-repository ppa:graphics-drivers/ppa
		sudo dpkg --add-architecture i386
		sudo nala update
		sudo nala install nvidia-driver-555 libvulkan1 libvulkan1:i386 -y
	elif [[ $gpu_info == *"Advanced Micro Devices"* ]]; then
		echo "AMD GPU detected. Installing AMD drivers..."

		sudo add-apt-repository ppa:kisak/kisak-mesa
		sudo dpkg --add-architecture i386
		sudo nala update
		sudo nala upgrade
		sudo nala install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y
	else
		echo "No NVIDIA or AMD GPU detected."
	fi
}

curlDownloads() {
	# Zoxide (smarter `cd` command)
	displayInstallMessage "zoxide"
	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

	# Nala (APT frontend replacement)
	displayInstallMessage "nala"
	curl https://gitlab.com/volian/volian-archive/-/raw/main/install-nala.sh | bash

	# Neovim
	displayInstallMessage "neovim"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

	if [ ! -d ~/.config/nvim/ ]; then
		mkdir ~/.config/nvim/
	fi

	mv "../Shell Configs/init.lua" "../Shell Configs/lua/" ~/.config/nvim/
	rm nvim-linux64.tar.gz

	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

gitDownloads() {
	# FZF (Command-line fuzzy finder)
	displayInstallMessage "fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
}

setupRepositories() {
	# Fastfetch
	sudo add-apt-repository ppa:zhangsongcui3371/fastfetch

	# Firefox
	sudo install -d -m 0755 /etc/apt/keyrings

	wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

	gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

	echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

	echo '
	Package: *
	Pin: origin packages.mozilla.org
	Pin-Priority: 1000
	' | sudo tee /etc/apt/preferences.d/mozilla
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
