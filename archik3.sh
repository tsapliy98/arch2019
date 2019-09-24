#!/bin/sh
echo 'Добавляем пользователя и ставим ему пароль'
useradd -m -g users -G wheel -s /bin/bash sergey
(
    echo 1998;
    echo 1998;
)   | passwd sergey

echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo 'переход на нового пользователя'
su - sergey


echo 'Установка основных программ'
echo 'Установка xorg'
sudo pacman -S xorg-server xorg-apps xorg-xinit --noconfirm --needed

echo 'Установка экранного менеджера'
sudo pacman -S i3-wm i3blocks i3lock dmenu  --noconfirm --needed

echo 'Установка экрана входа'
sudo pacman -S lightdm lightdm-gtk-greeter --noconfirm --needed

echo 'Установка драйверов'
sudo pacman -S xf86-video-intel lib32-intel-dri xf86-input-synaptics --noconfirm --needed 

echo 'Шрифты'
sudo pacman -S ttf-liberation ttf-droid ttf-dejavu --noconfirm --needed

echo 'Сетевая утилита'
sudo pacman -S networkmanager network-manager-applet networkmanager-openconnect --noconfirm --needed

echo "exec i3" >> ~/.xinitrc

echo 'Создание директорий'
mkdir ~/Downloads
mkdir ~/Documents
mkdir ~/Pictures
mkdir ~/Music
mkdir ~/Video
mkdir ~/.icons
mkdir ~/.themes


mkdir -p ~/.config/i3/config

cp /etc/i3/config ~/.config/i3/config

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


sudo systemctl enable lightdm NetworkManager
  


