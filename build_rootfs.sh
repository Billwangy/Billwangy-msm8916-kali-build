#!/bin/bash

# 创建根文件系统
mkdir -p rootfs
sudo debootstrap --arch=arm64 --variant=minbase \
    kali-rolling rootfs http://http.kali.org/kali

# Chroot 配置
sudo mount --bind /dev rootfs/dev
sudo mount --bind /proc rootfs/proc
sudo mount --bind /sys rootfs/sys

# 安装基础包
sudo chroot rootfs /bin/bash <<EOF
apt update
apt install -y kali-linux-core systemd-sysv
echo "nameserver 8.8.8.8" > /etc/resolv.conf
exit
EOF

# 生成 Initramfs
sudo chroot rootfs mkinitramfs -o /boot/initrd.img

# 打包 RootFS
mkdir -p output
sudo mksquashfs rootfs output/kali-rootfs.img -comp xz
