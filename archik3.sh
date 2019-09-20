#!/bin/sh
echo 'Установка основных программ'
#Установка xorg
sudo pacman -S xorg-server xorg-xinit xorg-xbacklight 

#Установка экранного менеджера
sudo pacman -S i3-wm i3status i3lock rofi firefox firefox-i18n-ru rxvt-unicode thunar vim feh lxappearance compton 

#Установка экрана входа
sudo pacman -S lightdm lightdm-gtk-greeter 

#Установка драйверов
sudo pacman -S xf86-video-intel lib32-mesa 

#Драйвера на Тачпад
sudo pacman -S xf86-input-synaptics 

#Драйвера на Звук
sudo pacman -S pulseaudio pulseaudio-bluetooth pulseaudio-alsa alsa-utils alsa-oss 

#Шрифты
sudo pacman -S ttf-liberation ttf-droid ttf-dejavu 

#Bluetooth
sudo pacman -S blueman blueman-manager-applet 

#Сетевая утилита
sudo pacman -S networkmanager network-manager-applet 

#Configs
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo "exec i3" >> ~/.xinitrc 

mkdir -p ~/.config/i3/config

mkdir -p ~/.config/i3status/config

cp /etc/i3/config ~/.config/i3/config

cp /etc/i3status.conf ~/.config/i3status/config


#Активация i3
systemctl enable NetworkManager lightdm.service

