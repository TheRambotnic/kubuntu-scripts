# Bash Scripts for [Kubuntu 22.04.3 LTS](https://kubuntu.org/)
These are some bash scripts I've made to make my life easier when installing/removing packages because I seriously can't be bothered to use the terminal to do shit manually... 😓

## Included:
* Remove Bloatware.sh
* Install Essentials.sh
* [Install Floorp Browser.sh](https://floorp.app/en/)
* Install Developer Packages.sh
* [Vencord Installer.sh](https://github.com/Vendicated/Vencord)
* [scrcpy.sh](https://github.com/Genymobile/scrcpy)

**HOW TO USE:** Open the scripts folder in the terminal and type `sudo chmod a+x ./*`, then run file you want.

## Keyboard Shortcuts
These are equivalent to Windows' shortcuts. `Meta` in this case would be the Windows logo key.

### Applications
* **Dolphin**
	* Shortcut: `Meta + E`
* **KRunner**
	* Shortcut: `Meta + R`
* **Flameshot**
	* Open launcher: `Print`
	* Take screenshot: `Meta + Shift + S`
* **System Monitor**
	* Shortcut: `Ctrl + Shift + Esc`
* **System Settings**
	* Shortcut: `Meta + I`

### System Services
* **Plasma**
	* Show Desktop: `Meta + M`
	* Open Klipper at Mouse Position: `Meta + V`
* **Session Management**
	* Lock Session: `Meta + L`

### Dolphin
* **Create Folder**
	* Shortcut: `Ctrl + Shift + N`
* **Editable Location**
	* Shortcut: `F4`
* **Terminal**
	* Shortcut: `NONE`

## Custom .bashrc Configs
Place these at the bottom of the file:

```bash
parse_git_branch() {
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
    if [ -n "$branch" ]; then
        echo " $branch"
    fi
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\] $ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi

# Replaces `cd` with zoxide
eval "$(zoxide init --cmd cd bash)"

# Custom Terminal Aliases
alias zquery='zoxide query -l -s | less'
```