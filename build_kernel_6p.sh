#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-

VER="\"-Googy-Max-Nexus_6P-v$1\""
cp -f /home/anas/Nexus_6P/Kernel/arch/arm64/configs/googymax-6P_defconfig /home/anas/Nexus_6P/googymax-6P_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/anas/Nexus_6P/googymax-6P_defconfig > /home/anas/Nexus_6P/Kernel/arch/arm64/configs/googymax-6P_defconfig

export ARCH=arm64
export SUBARCH=arm64

rm -f /home/anas/Nexus_6P/Kernel/arch/arm64/boot/Image*.*
rm -f /home/anas/Nexus_6P/Kernel/arch/arm64/boot/.Image*.*
make googymax-6P_defconfig || exit 1

make -j5 || exit 1

./tools/dtbtool3 -o /home/anas/Nexus_6P/Out/dt.img -s 4096 -p ./scripts/dtc/ arch/arm64/boot/dts/ || exit 1

cd /home/anas/Nexus_6P/Out
./packimg.sh

cd /home/anas/Nexus_6P/Release
zip -r ../Googy-Max-Nexus_6P_Kernel_${1}.zip .

adb push /home/anas/Nexus_6P/Googy-Max-Nexus_6P_Kernel_${1}.zip /sdcard/Googy-Max-Nexus_6P_Kernel_${1}.zip

adb kill-server

echo "Googy-Max-Nexus_6P_Kernel_${1}.zip READY !"
