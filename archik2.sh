#!/bin/sh

echo 'Создаем нового пользователя'
useradd -m -g users -G wheel,audio,disk,floppy,input,kvm,optical,scanner,storage,video,games,lp,power -s /bin/bash sergey

echo 'Пароль нового пользователя'
echo "sergey:1998" | chpasswd

echo 'sudoers'
sed -i 's/# wheel ALL=(ALL) ALL/wheel ALL=(ALL) ALL/' /etc/sudoers

echo ''
sed -i 's/#[multilib]\n#Include = /etc/pacman.d/mirrorlist/[multilib]\nInclude = /etc/pacman.d/mirrorlist/' /etc/pacman.conf
