#!/bin/sh
echo 'Создание директорий'
mkdir ~/Downloads
mkdir ~/Documents
mkdir ~/Music
mkdir ~/Video
mkdir ~/.icons
mkdir ~/.themes

mkdir -p ~/.config/i3status.config

cp /etc/i3status.conf ~/.config/i3status/config

echo 'Установка утилит'
(
    echo 1998;
)   | sudo pacman -S pcmanfm gvfs tar p7zip file-roller feh lxappearance unrar dosfstools ntfs-3g pulseaudio pulseaudio-bluetooth pulseaudio-alsa  alsa-lib alsa-utils --noconfirm --needed

echo 'Установка программ'
sudo pacman -S firefox firefox-i18n-ru libreoffice-fresh libre-office-fresh-ru libreffice-fresh-uk gnome-calculator vlc lxmusic gpicview evince vim compton screenfetch ufw qbittorrent kdeconnect git skype wget --noconfirm --needed

echo 'Установка yay'
cd /Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sir --needed --noconfirm --skippgpcheck

echo 'Установка программ из AUR'
(
    echo 1998;
)   | yay -S timeshift xkblayout-state onedrive --needed --noconfirm --skippgpcheck
