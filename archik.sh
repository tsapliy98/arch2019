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
	echo t;
	echo 1;
	

	echo n;	
	echo ;
	echo ;
	echo +512M;

	echo n;	
	echo ;
	echo ;
	echo ;
	

	echo t;	
	echo 3;
	echo 31;
	echo w;
)	| fdisk /dev/sda

echo 'Ваша разметка диска'
fdisk -l

echo 'Форматирование разделов'
mkfs.fat -F32 /dev/sda1
mkfs.ext2 /dev/sda2

echo 'Создание зашифрованого раздела'
cryptsetup luksFormat /dev/sda3

echo 'Открытие зашифрованого раздела'


cryptsetup open --type luks /dev/sda3 lvm

pvcreate --dataalinment 1m /dev/mapper/lvm

vgcreate vg_arch /dev/mapper/lvm

lvcreate -L 4GB vg_arch -n lv_swap
lvcreate -L 30GB vg_arch -n lv_root
lvcreate -l 100%FREE vg_arch -n lv_home

modprobe dm-mod
vgscan
vgchange -ay

mkswap /dev/vg_arch/lv_swap
mkfs.ext4 /dev/vg_arch/lv_root
mkfs.ext4 /dev/vg_arch/lv_home

swapon /dev//vg_arch/lv_swap
mount /dev/vg_arch/lv_root /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda2 /mnt/boot
mount /dev/vg_arch/lv_home /mnt/home

echo 'Выбор зеркал для загрузки'
vim /etc/pacman.d/mirrorlist

echo 'Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware linux-headers netctl dhcpcd lvm2
echo 'Настройка системы'
genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/archik2.sh)"

