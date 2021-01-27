ssh:
	mkdir -p ${HOME}/.ssh
	ln -vsf ${PWD}/.ssh/config ${HOME}/.ssh/config
	ln -vsf ${PWD}/.ssh/known_hosts ${HOME}/.ssh/known_hosts
	chmod 600 ${HOME}/.ssh/id_rsa

base:
	sudo pacman -S filesystem gcc-libs glibc bash coreutils file findutils gawk \
	grep procps-ng sed tar gettext pciutils psmisc shadow util-linux bzip2 gzip \
	xz licenses pacman systemd systemd-sysvcompat iputils iproute2 autoconf sudo \
	automake binutils bison fakeroot flex gcc groff libtool m4 make patch pkgconf \
	texinfo which man-db man-pages

dotfiles:
	test -L ${HOME}/.vim || rm -rf ${HOME}/.vim
	ln -vsfn ${PWD}/.vim ${HOME}/.vim
	test -L ${HOME}/.tmux_addons || rm -rf ${HOME}/.tmux_addons
	ln -vsfn ${PWD}/.tmux_addons ${HOME}/.tmux_addons
	test -L ${HOME}/.zsh || rm -rf ${HOME}/.zsh
	ln -vsfn ${PWD}/.zsh ${HOME}/.zsh
	test -d ${HOME}/.config || mkdir ${HOME}/.config
	test -L ${HOME}/.config/awesome || rm -rf ${HOME}/.config/awesome
	ln -vsfn ${PWD}/.config/awesome ${HOME}/.config/awesome
	test -L ${HOME}/.bundle || rm -rf ${HOME}/.bundle
	ln -vsfn ${PWD}/.bundle ${HOME}/.bundle
	ln -vsf ${PWD}/.gemrc ${HOME}/.gemrc
	ln -vsf ${PWD}/.gitconfig ${HOME}/.gitconfig
	ln -vsf ${PWD}/.gitmessage ${HOME}/.gitmessage
	ln -vsf ${PWD}/.gitmodules ${HOME}/.gitmodules
	ln -vsf ${PWD}/.gtktermrc ${HOME}/.gtktermrc
	ln -vsf ${PWD}/.profile ${HOME}/.profile
	ln -vsf ${PWD}/.tmux.conf ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.vimrc ${HOME}/.vimrc
	ln -vsf ${PWD}/.zprofile ${HOME}/.zprofile
	ln -vsf ${PWD}/.zsh_aliases ${HOME}/.zsh_aliases
	ln -vsf ${PWD}/.zshrc ${HOME}/.zshrc
	ln -vsf ${PWD}/.xprofile ${HOME}/.xprofile

blackarch:
	curl -O https://blackarch.org/strap.sh
	mv strap.sh /tmp/strap.sh
	chmod +x /tmp/strap.sh
	sudo /tmp/strap.sh
	sudo pacman -Syu

yay:
	sudo pacman -S yay

common-packages:
	sudo pacman -S aircrack-ng alsa-utils arandr arch-wiki-lite audacity \
	autoconf chromium cifs-utils code connman cryptsetup device-mapper \
	dhcpcd dialog diffutils discord dosfstools e2fsprogs evince fcitx \
	fcitx-configtool fcitx-mozc fcitx-qt5 fcrackzip firefox \
	firefox-i18n-ja foremost fprintd gedit gimp gksu gnuplot \
	gparted graphviz gvim hexedit htop inetutils iw jfsutils \
	jq less libfprint lvm2 lynx nano netctl ntfs-3g ntp \
	otf-ipafont pavucontrol pciutils procps-ng pulseaudio pulseaudio-alsa \
	sakura sl slock sysfsutils sysstat tar termite thunderbird \
	thunderbird-i18n-ja tlp tmux unzip usbutils util-linux vlc \
	wget words wpa_supplicant xarchiver xsel zip zsh
	yay -S heroku-cli jdk keepassx2 nkf preload trash-cli ttf-ms-fonts ttf-ricty
	chsh -s /usr/bin/zsh
	sudo cp ${PWD}/dicts/gene /usr/share/dict/
	wget git.io/trans -P ${HOME}/bin/
	chmod +x ${HOME}/bin/trans

gui:
	sudo pacman -S awesome blackarch-config-awesome lxappearance lxdm \
	lximage-qt lxqt-about lxqt-admin lxqt-config lxqt-globalkeys \
	lxqt-notificationd lxqt-openssh-askpass lxqt-panel lxqt-policykit \
	lxqt-powermanagement lxqt-qtplugin lxqt-runner lxqt-session \
	lxqt-sudo lxqt-themes lxtask obconf-qt openbox pavucontrol-qt \
	pcmanfm-qt xorg-iceauth xorg-server xorg-sessreg xorg-smproxy \
	xorg-twm xorg-x11perf xorg-xbacklight xorg-xclock xorg-xcmsdb \
	xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma \
	xorg-xhost xorg-xinit xorg-xinput xorg-xkbevd xorg-xkbutils \
	xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xpr xorg-xprop xorg-xrandr \
	xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo \
	xorg-xwud xterm
	yay -S archlinux-lxdm-theme-full lxqt-arc-dark-theme-git netctl-gui \
	netctlgui-helper openbox-arc-git xscreensaver-arch-logo 

pentest:
	sudo pacman -S burpsuite checksec gmp-ecm gnu-netcat hydra ltrace paros \
	nmap peda socat sqlmap steghide stegsolve strace wireshark-qt radare2 \
	zaproxy perl-image-exiftool 

docker:
	sudo pacman -S docker docker-compose
	sudo gpasswd -a ${USER} docker
	sudo systemctl start docker.service
	sudo systemctl enable docker.service

vagrant:
	sudo pacman -S vagrant virtualbox virtualbox-guest-iso virtualbox-host-modules-arch
	sudo modprobe vboxdrv
	sudo gpasswd -a ${USER} vboxusers

ruby:
	yay -S rbenv ruby-build
	eval "$(rbenv init -)"
	rbenv install 2.6.4
	rbenv global 2.6.4
	gem install bundler
	gem install pry
	gem install rails

javascript:
	sudo pacman -S nodejs npm yarn
	sudo npm -g install n
	sudo n latest

python:
	sudo pacman -S python python-colorama python-pip

dotnet:
	sudo yay -S dotnet-sdk icu55

install: ssh base dotfiles blackarch yay common-packages gui pentest docker vagrant ruby javascript python dotnet

backup:
	pacman -Qe >packages.txt
