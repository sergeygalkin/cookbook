#!/bin/bash
set -xe
VER=5.17.0
#REL='-r1'
REL=''
mount /boot
cd /usr/src/linux
make -j15
make modules_install
cp /usr/src/linux/arch/x86_64/boot/bzImage /boot/kernel-${VER}
dracut --xz -f /boot/initramfs-${VER}.img ${VER}-gentoo${REL}
grub-mkconfig -o /boot/grub2/grub.cfg
emerge -nO =gentoo-sources-${VER}${REL}
emerge x11-drivers/nvidia-drivers
emerge net-misc/r8125
emerge app-misc/openrazer
