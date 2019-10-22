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
(
	echo YES;
	echo 1998;
	echo 1998;
)	| cryptsetup luksFormat /dev/sda3

echo 'Открытие зашифрованого раздела'



