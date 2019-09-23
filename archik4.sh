#!/bin/sh
echo 'Создание директорий'
mkdir ~/Downloads
mkdir ~/Documents
mkdir ~/Music
mkdir ~/Video
mkdir ~/.icons
mkdir ~/.themes


mkdir -p ~/.config/i3status/config

cp /etc/i3status.conf ~/.config/i3status/config

echo 'Установка утилит'
sudo pacman -S  gvfs tar p7zip file-roller feh lxappearance unrar dosfstools ntfs-3g pulseaudio pulseaudio-bluetooth pulseaudio-alsa  alsa-lib alsa-utils --noconfirm --needed

echo 'Установка программ'
sudo pacman -S  libreoffice-fresh libreoffice-fresh-ru libreoffice-fresh-uk gnome-calculator vlc lxmusic gpicview evince vim compton screenfetch ufw qbittorrent kdeconnect  --noconfirm --needed

sudo pacman -Syyu 

cd Downloads
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si --needed --noconfirm --skippgpcheck
cd ~

echo 'Установка yay'
cd Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --needed --noconfirm --skippgpcheck
cd ~

cd Downloads
git clone https://aur.archlinux.org/timeshift.git
cd timeshift
makepkg -si --needed --noconfirm --skippgpcheck
cd ~

echo 'Установка программ из AUR'

yay -S  xkblayout-state onedrive --needed --noconfirm 

