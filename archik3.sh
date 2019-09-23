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
echo 'Установка xorg'
pacman -S xorg-server xorg-apps xorg-xinit --noconfirm --needed

echo 'Установка экранного менеджера'
pacman -S i3-wm i3status i3lock dmenu  --noconfirm --needed

echo 'Установка экрана входа'
pacman -S lightdm lightdm-gtk-greeter --noconfirm --needed

echo 'Установка драйверов'
pacman -S xf86-video-intel lib32-intel-dri xf86-input-synaptics --noconfirm --needed 

echo 'Шрифты'
pacman -S ttf-liberation ttf-droid ttf-dejavu --noconfirm --needed

echo 'Сетевая утилита'
pacman -S networkmanager network-manager-applet networkmanager-openconnect --noconfirm --needed
  


