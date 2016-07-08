#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-

VER="\"-GoogyMax-6P-N-v$1\""
cp -f /home/anas/Nexus_6P/Kernel/arch/arm64/configs/googymax-6P_defconfig /home/anas/Nexus_6P/googymax-6P_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/anas/Nexus_6P/googymax-6P_defconfig > /home/anas/Nexus_6P/Kernel/arch/arm64/configs/googymax-6P_defconfig

export ARCH=arm64
export SUBARCH=arm64

rm -f /home/anas/Nexus_6P/Kernel/arch/arm64/boot/Image*.*
rm -f /home/anas/Nexus_6P/Kernel/arch/arm64/boot/.Image*.*
make googymax-6P_defconfig || exit 1

make -j3 || exit 1

./tools/dtbtool3 -o /home/anas/Nexus_6P/Out_n/dt.img -s 4096 -p ./scripts/dtc/ arch/arm64/boot/dts/ || exit 1

cd /home/anas/Nexus_6P/Out_n
./packimg.sh

cd /home/anas/Nexus_6P/Release
zip -r ../GoogyMax-6P-N_Kernel_v${1}.zip .

adb push /home/anas/Nexus_6P/GoogyMax-6P-N_Kernel_v${1}.zip /sdcard/GoogyMax-6P-N_Kernel_v${1}.zip

adb kill-server

echo "GoogyMax-6P-N_Kernel_v${1}.zip READY !"
