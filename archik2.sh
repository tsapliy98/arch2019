#!/bin/sh
echo 'hostname'
echo "archik" > /etc/hostname

echo 'hosts'
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1" >> /etc/hosts
echo "127.0.1.1	archik.localdomain  archik" >> /etc/hosts

echo 'Часовой пояс'
ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime

echo 'Способ хранения таймера'
hwclock --systohc --utc

echo 'Добавляем локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_UA.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_UA.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo 'Устанавливаем загрузчик'
pacman -S grub efibootmgr --noconfirm
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=Archik --efi-directory=/boot/efi --recheck

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm

echo 'passwd'
(
    echo 1998;
    echo 1998;
)   | passwd 

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

echo 'Сетевая утилита'
pacman -S networkmanager network-manager-applet networkmanager-openconnect --noconfirm --needed

echo 'Включение менеджера входа и сетевой утилиты'
systemctl enable lightdm NetworkManager

echo 'Ставим загрузку i3'
echo "exec i3" >> ~/.xinitrc

echo 'Установка драйверов, шрифтов, программ'
echo 'Установка драйверов'
pacman -S xf86-video-intel lib32-intel-dri xf86-input-synaptics --noconfirm --needed 


echo 'Драйвера на Звук'
pacman -S pulseaudio pulseaudio-bluetooth pulseaudio-alsa alsa-utils alsa-oss --noconfirm --needed

echo 'Шрифты'
pacman -S ttf-liberation ttf-droid ttf-dejavu --noconfirm --needed

echo 'Программы'
pacman -S rxvt-unicode vim pcmanfm pcmanfm-gtk3 gvfs udisks firefox firefox-i18n-ru feh lxappaerance tar p7zip file-roller  --noconfirm --needed
