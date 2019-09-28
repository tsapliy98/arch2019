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
sudo pacman -S firefox firefox-i18n-ru qbittorrent feh gpicview vlc kdeconnect udiskie thunar p7zip tar File Roller unrar libreoffice-fresh libreoffice-fresh-ru libreoffice-fresh-uk atom evince xcalc compton lxappearance --noconfirm --needed



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







