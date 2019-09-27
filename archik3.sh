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
pacman -S i3-wm rofi rxvt-unicode --noconfirm --needed

echo 'Установка экрана входа'
pacman -S lightdm lightdm-gtk-greeter --noconfirm --needed

echo 'Установка драйверов Видео карты'
pacman -S xf86-video-intel lib32-intel-dri --noconfirm --needed 

echo 'Установка драйверов Тачпада'
pacman -S xf86-input-synaptics --noconfirm --needed 

echo 'Установка драйверов bluetooth'
pacman -S bluez bluez-utils blueman --noconfirm --needed 

echo 'Установка драйверов Звука'
pacman -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-lirc --noconfirm --needed

echo 'Шрифты'
pacman -S ttf-liberation ttf-droid ttf-dejavu artwiz-fonts  ttf-font-awesome --noconfirm --needed

echo 'Сетевая утилита'
pacman -S networkmanager network-manager-applet networkmanager-openconnect --noconfirm --needed

echo 'Добавление i3 в xinitrc'
echo "exec i3" >> ~/.xinitrc

echo 'Включение менеджера входа менеджера интернет и bluetooth'
systemctl enable lightdm NetworkManager bluetooth.service
 
echo 'Перезагрузка'
reboot

