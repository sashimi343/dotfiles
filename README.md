# My dotfiles

## Prerequirements

* Arch Linux installation has been finished with reference to [installation guide](https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89)
* SSH private keys are stored in `~/.ssh/`
* Git and Make are available


## Build environment

```console
make install
reboot
```

## Save(backup) current environment

```console
make backup
```

## Additional settings

#### Enable GUI

Install the appropriate display drivers for your environment.
See also [X.org - ArchWiki](https://wiki.archlinux.jp/index.php/Xorg#.E3.83.89.E3.83.A9.E3.82.A4.E3.83.90.E3.83.BC.E3.81.AE.E3.82.A4.E3.83.B3.E3.82.B9.E3.83.88.E3.83.BC.E3.83.AB)

```console
sudo pacman -Ss xf86-video
sudo pacman -S xf86-video-intel
```

Then launch display manager.

```console
sudo systemctl enable lxdm
sudo systemctl start lxdm
```
