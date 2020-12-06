# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -z "$TMUX" -a -z "$STY" ]; then
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

    # CapsLock -> Ctrl
    which setxkbmap && setxkbmap -option ctrl:nocaps

    # enable composition effect
    which compton && compton -CGb

    # enable natural scrolling 
    if xinput list-props "SynPS/2 Synaptics TouchPad" | grep -q "libinput Natural Scrolling Enabled"; then
        "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
    fi

    # start xscreensaver
    which xscreensaver && xscreensaver -no-splash &
fi
