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


echo 'Установка основных программ'
#Установка xorg
pacman -S xorg-server xorg-xinit xorg-xbacklight 

#Установка экранного менеджера
pacman -S i3-wm i3status i3lock rofi firefox firefox-i18n-ru rxvt-unicode thunar vim feh lxappearance compton 

#Установка экрана входа
pacman -S lightdm lightdm-gtk-greeter 

#Установка драйверов
pacman -S xf86-video-intel lib32-mesa 

#Драйвера на Тачпад
pacman -S xf86-input-synaptics 

#Драйвера на Звук
pacman -S pulseaudio pulseaudio-bluetooth pulseaudio-alsa alsa-utils alsa-oss 

#Шрифты
pacman -S ttf-liberation ttf-droid ttf-dejavu 

#Сетевая утилита
pacman -S networkmanager network-manager-applet 

