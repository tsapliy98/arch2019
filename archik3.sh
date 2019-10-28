#!/bin/bash

echo 'Welcome to install Arch Linux'
sleep 2

read -p 'Желаете разбить диск? [Y|n]: ' disk_settings
if [[ "$disk_settings" -eq "Y" ]]; then
    wget https://git.io/archik4.sh && sh archik4.sh
elif [[ "$disk_settings" -eq "n" ]]; then
    exit
fi 

sleep 2




read -p 'Шифрование [Y|n]' encrypt
if [[ "$encrypt" -eq "Y" ]]; then
    cryptsetup luksFormat /dev/sda3
    cryptsetup open --type luks /dev/sda3 lvm
    pvcreate --dataalignment 1m /dev/mapper/lvm
    vgcreate vg_arch /dev/mapper/lvm
    lvcreate -L 4GB vg_arch -n lv_swap
    lvcreate -L 30GB vg_arch -n lv_root
    lvcreate -l 100%FREE vg_arch -n lv_home
    modprobe dm-mod
    vgscan
    vgchange -ay
elif [[ "$encrypt" -eq "n" ]]; then
    exit
fi 

read -p 'Выберите форматирование: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM' formating
if [[ "$formating" -eq 1 ]]; then
    mkfs.ext2 /dev/sda1
    mkswap /dev/sda2
    mkfs.ext4 /dev/sda3
    mkfs.ext4 /dev/sda4
elif [[ "$formating" -eq 2 ]]; then
    mkfs.vfat /dev/sda1
    mkswap /dev/sda2
    mkfs.ext4 /dev/sda3
    mkfs.ext4 /dev/sda4
elif [[ "$formating" -eq 3 ]]; then
    mkfs.fat -F32 /dev/sda1
    mkfs.ext2 /dev/sda2
    mkswap /dev/vg_arch/lv_swap
    mkfs.ext4 /dev/vg_arch/lv_root
    mkfs.ext4 /dev/vg_arch/lv_home
fi
   
sleep 2 

read -p 'Выберите монтирование: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM' mount 
if [[ "$mount" -eq 1 ]]; then
    mount /dev/sda3 /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda4 /mnt/home
    swapon /dev/sda2
elif [[ "$mount" -eq 2 ]]; then
    mount /dev/sda3 /mnt
    mkdir /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda4 /mnt/home
    swapon /dev/sda2
elif [[ "$mount" -eq 3 ]]; then
    swapon /dev/vg_arch/lv_swap
    mount /dev/vg_arch/lv_root /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount /dev/sda2 /mnt/boot
    mount /dev/vg_arch/lv_home /mnt/home
fi

echo 'Выбор зеркал'
cat > /etc/pacman.d/mirrorlist <<"EOF"
## Ukraine
Server = http://mirrors.nix.org.ua/linux/archlinux/$repo/os/$arch
EOF

read -p 'Выберите установку: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM' installing
if [[ "$installing" -eq 1 ]]; then
    pacstrap /mnt base base-devel linux linux-firmware linux-headers netctl dhcpcd vim man-db man-pages texinfo vim wget git
elif [[ "$installing" -eq 2 ]]; then
    pacstrap /mnt base base-devel linux linux-firmware linux-headers netctl dhcpcd vim man-db man-pages texinfo vim wget git
elif [[ "$installing" -eq 3 ]]; then
    pacstrap /mnt base base-devel linux linux-firmware linux-headers netctl dhcpcd lvm2 vim man-db man-pages texinfo vim wget git 
fi

echo 'Fstab' 
genfstab -U -p /mnt >> /mnt/etc/fstab

read -p 'Выберите тип установки: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM' chrooting
if [[ "$chrooting" -eq 1 ]]; then
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
    echo 'Оновление initramfs'
    mkinitcpio -p linux
    echo 'Устанавливаем пароль рута'
    echo "root:1998" | chpasswd
    echo 'Ставим пакет загрузчика'
    pacman -S grub 
    echo 'Ставим сам загрузчик на диск'
    grub-install /dev/sda
    echo 'Обновляем конфиг загрузчика'
    grub-mkconfig -o /boot/grub/grub.cfg
    echo 'Ставим openssh'
    pacman -S openssh
    echo 'Ставим программы для wifi'
    pacman -S wpa_supplicant dialog
    echo 'Создаем нового пользователя'
    useradd -m -g users -G audio,lp,optical,power,scanner,storage,video,wheel -s /bin/bash sergey
    echo 'Пароль нового пользователя'
    echo "sergey:1998" | chpasswd
    echo 'sudoers'
    sed -i 's|^# wheel ALL=(ALL) ALL|wheel ALL=(ALL) ALL|' /etc/sudoers
    echo 'multilib'
    sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf 
    echo 'Обновление зеркалов'
    pacman -Syy
    echo 'Выходим из установленой системы'
    exit
EOF
elif [[ "$chrooting" -eq 2 ]]; then
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
    echo 'Оновление initramfs'
    mkinitcpio -p linux
    echo 'Устанавливаем пароль рута'
    echo "root:1998" | chpasswd
    echo 'Ставим пакет загрузчика'
    pacman -S grub efibootmgr
    echo 'Создаем директорию для загрузчика'
    mkdir /boot/efi
    echo 'Монтируем диск с загрузчиком'
    mount /dev/sda1 /boot/efi
    echo 'Ставим сам загрузчик на диск'
    grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
    echo 'Обновляем конфиг загрузчика'
    grub-mkconfig -o /boot/grub/grub.cfg
    echo 'Ставим openssh'
    pacman -S openssh
    echo 'Ставим программы для wifi'
    pacman -S wpa_supplicant dialog
    echo 'Создаем нового пользователя'
    useradd -m -g users -G audio,lp,optical,power,scanner,storage,video,wheel -s /bin/bash sergey
    echo 'Пароль нового пользователя'
    echo "sergey:1998" | chpasswd
    echo 'sudoers'
    sed -i 's|^# wheel ALL=(ALL) ALL|wheel ALL=(ALL) ALL|' /etc/sudoers
    echo 'multilib'
    sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf 
    echo 'Обновление зеркалов'
    pacman -Syy
    echo 'Выходим из установленой системы'
    exit
EOF
elif [[ "$chrooting" -eq 3 ]]; then
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
    sed -i 's/HOOKS=(base udev autodetect modconf block filesystems     keyboard fsck)/HOOKS=(base udev autodetect modconf block encrypt lvm2   resume filesystems keyboard fsck)/' /etc/mkinitcpio.conf
    echo 'Оновление initramfs'
    mkinitcpio -p linux
    echo 'Устанавливаем пароль рута'
    echo "root:1998" | chpasswd
    echo 'Ставим пакет загрузчика'
    pacman -S grub efibootmgr
    echo 'Создаем директорию для загрузчика'
    mkdir /boot/efi
    echo 'Монтируем диск с загрузчиком'
    mount /dev/sda1 /boot/efi
    echo 'Ставим сам загрузчик на диск'
    grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
    echo 'Настраиваем загрузчик'
    sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|    GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/mapper/vg_arch-lv_swap cryptdevice=/dev/sda3:vg_arch loglevel=3 quiet"|' /etc/default/grub
    echo 'Обновляем конфиг загрузчика'
    grub-mkconfig -o /boot/grub/grub.cfg
    echo 'Ставим openssh'
    pacman -S openssh
    echo 'Ставим программы для wifi'
    pacman -S wpa_supplicant dialog
    echo 'Создаем нового пользователя'
    useradd -m -g users -G audio,lp,optical,power,scanner,storage,video,wheel -s /bin/bash sergey
    echo 'Пароль нового пользователя'
    echo "sergey:1998" | chpasswd
    echo 'sudoers'
    sed -i 's|^# wheel ALL=(ALL) ALL|wheel ALL=(ALL) ALL|' /etc/sudoers
    echo 'multilib'
    sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf 
    echo 'Обновление зеркалов'
    pacman -Syy
    echo 'Выходим из установленой системы'
    exit
EOF

echo 'Размонтируем mnt'
umount -R /mnt

echo 'Перезагружаемся'
reboot
    
