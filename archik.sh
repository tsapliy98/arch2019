#!/bin/sh

echo 'Установка раскладки клавиатуры'
loadkeys ru
setfont cyr-sun16

echo 'Синхронизация системных часов'
timedatectl set-ntp true

echo 'Создание разделов'
(
	echo g;
	
	echo n;
	echo ;
	echo ;
	echo +512M;
	

	echo n;	
	echo ;
	echo ;
	echo +4G;

	echo n;	
	echo ;
	echo ;
	echo +20G;
	

	echo n;	
	echo ;
	echo ;
	echo ;
	

	echo t;	
	echo 1;
	echo 1;

	echo t;	
	echo 2;
	echo 19;
	
	echo w;
)	| fdisk /dev/sda

echo 'Ваша разметка диска'
fdisk -l

echo 'Форматирование дисков'
mkfs.fat -F32 /dev/sda1 
mkswap /dev/sda2
(
	echo y;
)	| mkfs.ext4 /dev/sda3
(
	echo y;
)	| mkfs.ext4 /dev/sda4

echo 'Монтирование дисков'
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/home
mount /dev/sda4 /mnt/home

echo 'Выбор зеркал для загрузки'
echo "Server = http://mirrors.nix.org.ua/linux/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo 'Установка основных пакетов'
pacstrap /mnt base base-devel xorg-server xorg-apps xorg-xinit i3-wm i3status i3lock dmenu lightdm lightdm-gtk-greeter xf86-video-intel lib32-intel-dri xf86-input-synaptics rxvt-unicode

echo 'Настройка системы'
genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/archik2.sh)"


