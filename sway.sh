#!/bin/bash

# use your aur helper of choice if you don't like paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

sudo pacman -S sway swaylock swayidle kitty firefox-nightly wofi xorg-xwayland waybar mako catgirl mopidy-spotify ncmpcpp cava imv mpv ranger zathura htop neofetch unzip zip zsh zsh-autosuggestions zsh-syntax-highlighting

echo "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
sudo reboot