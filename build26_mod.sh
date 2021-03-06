#!/bin/bash

PATH="/home/<username>/freshtomato-mips/tools/brcm/hndtools-mipsel-linux/bin:$PATH"
PATH="/home/<username>/freshtomato-mips/tools/brcm/hndtools-mipsel-uclibc/bin:$PATH"

##############################
## clean and reset FT sources
##############################
cd $HOME/freshtomato-mips 
git clean -dxf 
git reset --hard
git checkout mips-RT-AC

################################
## build mipsel-toolchain
################################
cd $HOME/buildroot-2011.02
make clean
make

#################################
## create missing links
################################
cd $HOME/buildroot-2011.02/output/host/usr/bin
ln -nsf mipsel-linux-uclibc-gcc-4.2.4 mipsel-linux-uclibc-gcc
ln -nsf mipsel-linux-uclibc-gcc-4.2.4 mipsel-linux-gcc-4.2.4
ln -nsf mipsel-linux-uclibc-gcc-4.2.4 mipsel-uclibc-gcc-4.2.4

ln -nsf mipsel-linux-gcc mipsel-linux-cc
ln -nsf mipsel-linux-uclibc-g++ mipsel-uclibc-g++
ln -nsf mipsel-linux-uclibc-ar mipsel-uclibc-ar
ln -nsf mipsel-linux-uclibc-gcc mipsel-uclibc-gcc
ln -nsf mipsel-linux-uclibc-ld mipsel-uclibc-ld
ln -nsf mipsel-linux-uclibc-nm mipsel-uclibc-nm
ln -nsf mipsel-linux-uclibc-objcopy mipsel-uclibc-objcopy
ln -nsf mipsel-linux-uclibc-objdump mipsel-uclibc-objdump
ln -nsf mipsel-linux-uclibc-ranlib mipsel-uclibc-ranlib
ln -nsf mipsel-linux-uclibc-size mipsel-uclibc-size
ln -nsf mipsel-linux-uclibc-strings mipsel-uclibc-strings
ln -nsf mipsel-linux-uclibc-strip mipsel-uclibc-strip

cd ..
mkdir -p target-utils
mv bin/ldd target-utils
mv bin/ldconfig target-utils
mv mipsel-linux-uclibc/sysroot/usr/include/* include

#####################################
## remove original toolchain
#####################################
cd $HOME/freshtomato-mips/tools/brcm
rm -f hndtools-mipsel-linux
rm -f hndtools-mipsel-uclibc

#####################################
## install new toolchain
#####################################

cp -rf $HOME/buildroot-2011.02/output/host/usr K26/hndtools-mipsel-uclibc-4.2.4

ln -nsf K26/hndtools-mipsel-uclibc-4.2.4 hndtools-mipsel-linux
ln -nsf K26/hndtools-mipsel-uclibc-4.2.4 hndtools-mipsel-uclibc

#####################################
## patch FT sources and build FT
#####################################

cd $HOME/freshtomato-mips 

patch -i $HOME/Dokumente/freshtomato-mips/common.mak.patch $HOME/freshtomato-mips/release/src/router/common.mak
patch -i $HOME/Dokumente/freshtomato-mips/Makefile.linux.patch $HOME/freshtomato-mips/release/src/router/miniupnpd/Makefile.linux
patch -i $HOME/Dokumente/freshtomato-mips/genconfig.sh.patch $HOME/freshtomato-mips/release/src/router/miniupnpd/genconfig.sh
rm -f /home/stephan/freshtomato-mips/release/src/router/nettle/desdata.stamp

patch -i $HOME/Dokumente/freshtomato-mips/Makefile_RT-AC.patch $HOME/freshtomato-mips/release/src/router/Makefile

cd release/src-rt-6.x
patch -i $HOME/Dokumente/freshtomato-mips/mksquashfs.c.patch $HOME/freshtomato-mips/release/src-rt-6.x/linux/linux-2.6/scripts/squashfs/mksquashfs.c
make wndr4500v2z



