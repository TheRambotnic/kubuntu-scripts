# Bash Scripts for Ubuntu Linux 20.04
These are some bash scripts I've made to make my life easier when installing/removing packages because I seriously can't be bothered to use the terminal to do shit manually... 😓

## Included:
* remove-bloatware.sh
* install-essentials.sh
* install-opera.sh
* install-developer-packages.sh

**HOW TO USE:** Place the above files in any folder, open the terminal inside of said folder and run the following command: `chmod a+x ./*`. After that, simply double click it and choose `Run in Terminal`. Otherwise, you can simply type `./<name-of-file>.sh` to run it inside the terminal.

## Keyboard Shortcuts

### Custom
* **Open System Monitor**
	* **Shortcut:** CTRL + SHIFT + ESC
	* **Command:** gnome-system-monitor
* **Open System Settings**
	* **Shortcut:** SUPER + I
	* **Command:** gnome-control-center
* **Open Terminal**
	* **Shortcut:** CTRL + ALT + T
	* **Command:** mate-terminal
* **Open File Explorer**
	* **Shortcut:** SUPER + E
	* **Command:** caja

### Default
* **Show the run command prompt**
	* **Shortcut:** SUPER + R

## Configuring Caja to manage folders
By default, Ubuntu handles folders with Nautilus. To make the OS handle folders with Caja, simply right click any folder and select `Open With > Other Application`. From the list of applications, select Caja and check the `Remember this application for "folder" files` option.