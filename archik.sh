#!/bin/sh

echo 'Установка раскладки клавиатуры'
loadkeys ru

echo 'Установка шрифта для кирилицы'
setfont cyr-sun16

echo 'Синхронизация системных часов'
timedatectl set-ntp true

echo 'Разметка дисков'
(
	echo g;
	
	echo n;
	echo ;
	echo ;
		y;
	echo +512M;
	
	echo t;
	echo 1;
	
	
	echo n;
	echo ;
	echo ;
		y;
	echo +512M
	
	echo n;
	echo ;
	echo ;
	echo ;
		y;
	echo t;
	echo 3;
	echo 31;
	echo w;
	
)	| fdisk /dev/sda

echo 'Форматирование разделов'
mkfs.fat -F32 /dev/sda1

mkfs.ext2 /dev/sda2

echo 'Создание зашифрованого раздела'
cryptsetup luksFormat /dev/sda3

echo 'Открытие зашифрованого раздела'
cryptsetup open --type luks /dev/sda3 lvm

echo 'Создание физического тома'
pvcreate --dataalignment 1m /dev/mapper/lvm

echo 'Создание группы логического тома'
vgcreate vg_arch /dev/mapper/lvm

echo 'Создание логических томов'
lvcreate -L 4GB vg_arch -n lv_swap

lvcreate -L 30GB vg_arch -n lv_root

lvcreate -l 100%FREE vg_arch -n lv_home

echo 'Создание файловых систем и их монтирование'
modprobe dm-mod

vgscan

vgchange -ay

mkswap /dev/vg_arch/lv_swap

mkfs.ext4 /dev/vg_arch/lv_root

mkfs.ext4 /dev/vg_arch/lv_home

echo 'Монтирование разделов'
swapon /dev//vg_arch/lv_swap

mount /dev/vg_arch/lv_root /mnt

mkdir /mnt/boot

mkdir /mnt/home

mount /dev/sda2 /mnt/boot

mount /dev/vg_arch/lv_home /mnt/home

echo 'Выбор зеркал'
cat > /etc/pacman.d/mirrorlist <<"EOF"
## Ukraine
Server = http://mirrors.nix.org.ua/linux/archlinux/$repo/os/$arch
EOF

echo 'Установка основных пакетов'
pacstrap -i /mnt base base-devel linux linux-firmware linux-headers netctl dhcpcd lvm2 vim man-db man-pages texinfo vim wget git 

echo 'Fstab' 
genfstab -U -p /mnt >> /mnt/etc/fstab

echo 'Переход в установленную систему'
arch-chroot /mnt <<EOF

echo 'Часовой пояс'
ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime

echo 'Синхронизация времени'
hwclock --systohc --utc

echo 'Локализация'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
echo "ru_UA.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_UA KOI8-U" >> /etc/locale.gen

echo 'Обновляем локализацию'
locale-gen

echo 'Настраиваем язык системы'
echo "LANG=ru_UA.UTF-8" >> /etc/locale.conf

echo 'Настраиваем шрифт системы'
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf

echo 'Настройка hostmane'
echo "archik" >> /etc/hostname

echo 'Настройка hosts'
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	archik.localdomain	archik" >> /etc/hosts

echo 'Настройка initramfs'
sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block encrypt lvm2 resume filesystems keyboard fsck)/' /etc/mkinitcpio.conf

echo 'Оновление initramfs'
mkinitcpio -p linux
EOF

arch-chroot /mnt <<EOF
echo 'Ставим пакет загрузчика'
pacman -S grub efibootmgr

echo 'Создаем директорию для загрузчика'
mkdir /boot/efi

echo 'Монтируем диск с загрузчиком'
mount /dev/sda1 /boot/efi

echo 'Ставим сам загрузчик на диск'
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

echo 'Настраиваем загрузчик'
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/mapper/vg_arch-lv_swap cryptdevice=/dev/sda3:vg_arch loglevel=3 quiet"|' /etc/default/grub

echo 'Обновляем конфиг загрузчика'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим openssh'
pacman -S openssh

echo 'Ставим программы для wifi'
pacman -S wpa_supplicant dialog

echo 'Выходим из установленой системы'
exit
EOF

echo 'Размонтируем mnt'
umount -R /mnt

echo 'Перезагружаемся'
reboot
