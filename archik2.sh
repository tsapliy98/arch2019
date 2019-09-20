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
grub-install --target=x86_64-efi --bootloader-id=Arch Linux --efi-directory=/boot/efi --recheck

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm

echo 'passwd'
(
    echo 1998;
    echo 1998;
)   | passwd 



