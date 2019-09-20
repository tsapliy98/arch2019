#!/bin/sh
echo 'Установка основных программ'
#Установка xorg
sudo pacman -S xorg-server xorg-xinit xorg-xbacklight --noconfirm

#Установка экранного менеджера
sudo pacman -S i3-wm i3status i3lock rofi firefox firefox-i18n-ru rxvt-unicode thunar vim feh lxappearance compton --noconfirm

#Установка экрана входа
sudo pacman -S lightdm lightdm-gtk-greeter --noconfirm

#Установка драйверов
sudo pacman -S xf86-video-intel lib32-mesa mesa --noconfirm

#Драйвера на Тачпад
sudo pacman -S xf86-input-synaptics --noconfirm

#Драйвера на Звук
sudo pacman -S pulseaudio pulseaudio-bluetooth pulseaudio-alsa alsa-utils alsa-oss --noconfirm

#Шрифты
sudo pacman -S ttf-liberation ttf-droid ttf-dejavu --noconfirm

#Bluetooth
sudo pacman -S blueman blueman-manager-applet --noconfirm

#Сетевая утилита
sudo pacman -S networkmanager network-manager-applet --noconfirm

#Configs
#cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo "exec i3#" >> ~/.xinitrc 


#Активация i3
systemctl enable NetworkManager lightdm.service

