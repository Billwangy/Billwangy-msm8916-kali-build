#!/bin/bash

# 安装依赖
sudo apt update
sudo apt install -y git build-essential bc libssl-dev \
    crossbuild-essential-arm64 device-tree-compiler

# 克隆内核源码
git clone --depth=1 https://github.com/OpenStick/linux
cd linux

# 交叉编译配置
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make msm8916_defconfig

# 启用 Kali 所需模块
sed -i 's/# CONFIG_WIRELESS is not set/CONFIG_WIRELESS=y/' .config
make olddefconfig

# 编译内核与设备树
make -j$(nproc) Image.gz dtbs

# 合并内核与设备树
cat arch/arm64/boot/Image.gz arch/arm64/boot/dts/qcom/msm8916-openstick.dtb > ../kernel-dtb
cd ..
