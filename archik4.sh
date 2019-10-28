#!/bin/bash

read -p "Выберите разметку диска: 1 MBR; 2 GPT_UEFI; 3 GPT_UEFI_LVM; " disk
if [[ "$disk" -eq 1 ]]; then
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
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
    EOF
elif [[ "$disk" -eq 2 ]]; then
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
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
    EOF
elif [[ "$disk" -eq 3 ]]; then
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
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
    EOF
fi 






