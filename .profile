# ~/.profile: executed by the command interpreter for login shells.

# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

#/usr/bin/dropbox start -i &
#HOME=$HOME/.myDropbox /usr/bin/dropbox start -i

# CapsLock -> Ctrl
which setxkbmap && setxkbmap -option ctrl:nocaps

# disable touchpad while typing
#syndaemon -i 0.5 -t &

# enable composition effect
which compton && compton -CGb

# enable natural scrolling 
if xinput list-props "SynPS/2 Synaptics TouchPad" | grep -q "libinput Natural Scrolling Enabled"; then
    "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
fi

# start xscreensaver
which xscreensaver && xscreensaver -no-splash &
