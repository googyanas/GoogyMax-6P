#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
# export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
export CROSS_COMPILE=/home/anas/Nexus_6P/toolchains/sabermod/bin/aarch64-

VER="\"-GoogyMax-6P-MM-v$1\""
cp -f /home/anas/Nexus_6P/Kernel/arch/arm64/configs/googymax-6P_defconfig /home/anas/Nexus_6P/googymax-6P_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/anas/Nexus_6P/googymax-6P_defconfig > /home/anas/Nexus_6P/Kernel/arch/arm64/configs/googymax-6P_defconfig

export ARCH=arm64
export SUBARCH=arm64

rm -f /home/anas/Nexus_6P/Kernel/arch/arm64/boot/Image*.*
rm -f /home/anas/Nexus_6P/Kernel/arch/arm64/boot/.Image*.*
make googymax-6P_defconfig || exit 1

make -j3 || exit 1

./tools/dtbtool3 -o /home/anas/Nexus_6P/Out/dt.img -s 4096 -p ./scripts/dtc/ arch/arm64/boot/dts/ || exit 1

cd /home/anas/Nexus_6P/Out
./packimg.sh

cd /home/anas/Nexus_6P/Release
zip -r ../GoogyMax-6P-MM_Kernel_v${1}.zip .

adb push /home/anas/Nexus_6P/GoogyMax-6P-MM_Kernel_v${1}.zip /sdcard/GoogyMax-6P-MM_Kernel_v${1}.zip

adb kill-server

echo "GoogyMax-6P_Kernel-MM_v${1}.zip READY !"
