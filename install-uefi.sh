#!/usr/bin/env bash
# inspired by EF
# you should be in arch-chroot already

# config
USER_NAME=user
HOST_NAME=hostname
TIMEZONE=region/city
LOCALE=locale

# change to your timezone
ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc
# if you use a different locale, edit to fit yours
sed -i "s/#\s*${LOCALE}/${LOCALE}/" /etc/locale.gen
locale-gen 

if [[ -s /etc/locale.conf ]]; then
    echo 'there is something here already'
else
    echo "LANG=${LOCALE}.UTF-8" >> /etc/locale.conf
fi

if [[ -s /etc/hostname ]]; then
    echo 'there is something here already'
else
    echo "${HOST_NAME}" >> /etc/hostname
fi

echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t${HOST_NAME}.lan ${HOST_NAME}" >> /etc/hosts

# my list of packages I want to install for general linux (tlp not needed if not using laptop)
# earlier in my install I pacstrap w/ linux linux-firmware base base-devel vim git amd-ucode
pacman -Syu
pacman -S \
grub \
efibootmgr \
networkmanager \
network-manager-applet \
dialog \
wpa_supplicant \
reflector \
linux-headers \
avahi \
xdg-user-dirs \
xdg-utils \
gvfs \
inetutils \
bluez \
bluez-utils \
blueberry \
cups \
hplip \
alsa-utils \
pipewire \
pipewire-alsa \
pipewire-pulse \
openssh \
rsync \
acpi \
acpilight \
tlp \
sof-firmware \
curl \
jq \
tree \
wget \
zip \
unzip \
git \
vim \
ack \
ripgrep \
fzf \
fasd \
dog \
man-db \
htop \
sudo \
ranger \
ncdu \
fd-find


# install nouveau drivers if you have nvidia gpu (for wayland)
echo "checking your gpu driver"
if lspci -v | grep -i 'intel.*hd' > /dev/null; then
  if pacman -Qs xf86-video-intel; then
    echo "you have the intel driver"
  else
    echo "installing the intel driver..."
    sudo pacman -S xf86-video-intel
    echo "you have the intel driver now"
  fi
elif lspci -v | grep -i 'amd' > /dev/null; then
  if pacman -Qs xf86-video-amdgpu; then
    echo "you have the amd driver"
  else
    echo "installing the amd driver..."
    sudo pacman -S xf86-video-amdgpu
    echo "you have the amd driver now"
  fi
elif lspci -v | grep -i 'vmware' > /dev/null; then
  if pacman -Qs xf86-video-vmware; then
    echo "you have the vmware driver"
  else
    echo "installing the vmware driver..."
    sudo pacman -S xf86-video-vmware
    echo "you have the vmware driver now"
  fi
else
    echo "no gpu detected..."
fi

# don't do this for mbr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# enable systemd services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
if pacman -Qs tlp; then
    echo "you got tlp!"
    systemctl enable tlp
    echo "tlp enabled!"
else
    echo "you don't got tlp... unfortunate"
fi

# adds you to the wheel so you can steer the ship matey
useradd -mG wheel ${USER_NAME}
passwd ${USER_NAME}
sed -i 's/#\s*%wheel ALL=(ALL) N/%wheel ALL=(ALL) N/' /etc/sudoers

# random cool password for root
ROOT_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32; echo '')
echo "root:${ROOT_PASSWORD}" | chpasswd
echo "${ROOT_PASSWORD}" >> "/home/${USER_NAME}/root_password"
chown "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/root_password"
chmod 600 "/home/${USER_NAME}/root_password"

printf "\e[1;32mDone! exit, umount -a and reboot.\e[0m"