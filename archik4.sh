#!/bin/bash

read -p "Выберите разметку диска: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM; " disk
if [[ "$disk" -eq 1 ]]; then
    ( 
        o
        n
        p
        ;
        ;
        +512M
            y
        a
        n
        p
        ;
        ;
        +2G
            y
        n
        p
        ;
        ;
        +20G
            y
        n
        p
        ;
        ;
        ;
            y
        t
        2
        82
        w
    )   | fdisk /dev/sda
elif [[ "$disk" -eq 2 ]]; then
    ( 
        g
        n
        ;
        ;
        +512M
            y
        t
        1
        n
        ;
        ;
        +2G
            y
        n
        ;
        ;
        +20G
            y
        n
        ;
        ;
        ;
            y
        t
        2
        19
        w
    )   | fdisk /dev/sda
elif [[ "$disk" -eq 3 ]]; then
    ( 
        g
        n
        ;
        ;
        +512M
            y
        t
        1
        n
        ;
        ;
        +512M
            y
        n
        ;
        ;
        ;
            y
        t
        3
        31
        w
   )    | fdisk /dev/sda
fi 






