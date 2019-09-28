#!/bin/sh
echo 'Создание директорий'
mkdir ~/Downloads
mkdir ~/Documents
mkdir ~/Pictures
mkdir ~/Music
mkdir ~/Video
mkdir ~/.icons
mkdir ~/.themes

echo 'Установка программ'
sudo pacman -S firefox firefox-i18n-ru qbittorrent feh gpicview vlc kdeconnect udiskie thunar p7zip tar File Roller unrar libreoffice-fresh libreoffice-fresh-ru libreoffice-fresh-uk atom evince xcalc compton lxappearance 



sudo pacman -Syyu 

cd Downloads
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si 
cd ~

echo 'Установка yay'
cd Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si 
cd ~

yay -S ttf-ms-fonts ttf-tahoma ttf-vista-fonts pa-applet-git polybar timeshift xkblayout-state  

mkdir -p ~/.config/polybar
cp /usr/share/doc/polybar/config ~/.config/polybar







