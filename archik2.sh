#!/bin/sh

echo 'Создаем нового пользователя'
useradd -m -g users -G wheel,audio,disk,floppy,input,kvm,optical,scanner,storage,video,games,lp,power -s /bin/bash sergey

echo 'Пароль нового пользователя'
echo "sergey:1998" | chpasswd

echo 'sudoers'
sed -i 's|^# wheel ALL=(ALL) ALL|wheel ALL=(ALL) ALL|' /etc/sudoers

echo 'multilib'
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf 

echo 'Обновление зеркалов'
pacman -Syy

echo 'Установка Xorg' 
pacman -S xorg-server xorg-apps xorg-xinit

echo 'Установка Драйверов'
pacman -S xf86-video-intel lib32-intel-dri intel-ucode

echo 'Установка оконного менеджера'
pacman -S i3-wm i3lock 

echo 'Установка экранного менеджера'
pacman -S lightdm lightdm-gtk-greeter

echo 'Установка директории пользователя'
pacman -S xdg-user-dirs 

echo 'Установка драйвера тачпада'
pacman -S xf86-input-synaptics

echo 'Установка звука'
pacman -S alsa-lib alsa-utils alsa-oss 
