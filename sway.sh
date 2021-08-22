#!/bin/bash

# use your aur helper of choice if you don't like yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# need to install Mononoki (NF), Material Design Icons Desktop, and Inter fonts, betterdiscord, and your browser of choice
yay -S noto-color-emoji-fontconfig \
sway \
swayidle \
kitty \
wofi \
xorg-xwayland \
waybar \
neofetch \
sddm \
slurp \
grim \
swappy \
ranger \
cava \
imv \
mpv \
ranger \
zathura \
neofetch \
unzip \
zip \
gruvbox-dark-gtk \
gruvbox-dark-icons-gtk \
hexchat \
imagemagick \
mako \
nautilus \
paleofetch \
qalculate-gtk \
sddm \
spotify \
spicetify-cli \
swaylock-effects-git \
zsh \
zsh-autosuggestions \
zsh-syntax-highlighting \
zsh-theme-powerlevel10k-git \
chili-sddm-theme

echo "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
sudo reboot