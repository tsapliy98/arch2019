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
pacman -S i3-wm i3status i3lock  --noconfirm --needed

echo 'Установка экрана входа'
pacman -S lightdm lightdm-gtk-greeter --noconfirm --needed

echo 'Установка драйверов'
pacman -S xf86-video-intel lib32-intel-dri --noconfirm --needed 

echo 'Драйвера на Тачпад'
pacman -S xf86-input-synaptics --noconfirm --needed

echo 'Драйвера на Звук'
pacman -S pulseaudio pulseaudio-bluetooth pulseaudio-alsa alsa-utils alsa-oss --noconfirm --needed

echo 'Шрифты'
pacman -S ttf-liberation ttf-droid ttf-dejavu --noconfirm --needed

echo 'Сетевая утилита'
pacman -S networkmanager network-manager-applet --noconfirm --needed

echo 'Установка Дополнительных программ'
echo 'Терминал'
pacman -S rxvt-unicode --noconfirm --needed

echo 'Обои и темы'
pacman -S feh lxappearance --noconfirm --needed

echo 'Меню Композитор Редактор'
pacman -S rofi compton gedit --noconfirm --needed

echo 'Чтение и скорость носителей'
pacman -S hdparm --noconfirm --needed

echo 'Архивы'
pacman -S p7zip unrar file-roller --noconfirm --needed

echo 'Ськмные носители'
pacman -S gvfs polkit-gnome ntfs-3g --noconfirm --needed

echo 'Аудио Видео Изображение PDF'
pacman -S vlc lxmusic gpicview evince --noconfirm --needed

echo 'Офис'
pacman -S libreoffice-fresh libre-office-fresh-ru libreffice-fresh-uk --noconfirm --needed

echo 'Браузер'
pacman -S firefox firefox-i18n-ru --noconfirm --needed

echo 'Создание папок и копирование конфигов'
su - sergey
echo "exec i3" >> ~/.xinitrc
mkdir -p ~/.config/i3/config
mkdir -p ~/.config/i3status/config
cp /etc/i3/config ~/.config/i3/config
cp /etc/i3status.conf ~/.config/i3status/config
su - root

echo 'Включение менеджера входа и менеджера сети'
systemctl enable lightdm NetworkManager

exho 'Запуск Иксов и завершение скрипта'
startx
exit
