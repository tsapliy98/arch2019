#!/bin/bash

read -p "Выберите разметку диска: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM; " disk
if [[ "$disk" -eq 1 ]]; then
    ( 
       echo o;
       echo n;
       echo p;
       echo ;
       echo ;
       echo +512M;
       echo         y;
       echo a;
       echo n;
       echo p;
       echo ;
       echo ;
       echo +2G;
       echo         y;
       echo n;
       echo p;
       echo ;
       echo ;
       echo +20G;
       echo         y;
       echo n;
       echo p;
       echo ;
       echo ;
       echo ;
       echo         y;
       echo t;
       echo 2;
       echo 82;
       echo w;
    )   | fdisk /dev/sda
elif [[ "$disk" -eq 2 ]]; then
    ( 
       echo g;
       echo n;
       echo ;
       echo ;
       echo +512M;
       echo         y;
       echo t;
       echo 1;
       echo n;
       echo ;
       echo ;
       echo +2G;
       echo         y;
       echo n;
       echo ;
       echo ;
       echo +20G;
       echo         y;
       echo n;
       echo ;
       echo ;
       echo ;
       echo         y;
       echo t;
       echo 2;
       echo 19;
       echo w;
    )   | fdisk /dev/sda
elif [[ "$disk" -eq 3 ]]; then
    ( 
       echo g;
       echo n;
       echo ;
       echo ;
       echo +512M;
       echo         y;
       echo t;
       echo 1;
       echo n;
       echo ;
       echo ;
       echo +512M;
       echo         y;
       echo n;
       echo ;
       echo ;
       echo ;
                    y;
       echo t;
       echo 3;
       echo 31;
       echo w;
   )    | fdisk /dev/sda
fi 






