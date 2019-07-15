#! /bin/bash

DOWNLOAD=0

TDIR=`pwd`

rm -rf usr
rm -rf sysroot

#  x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-render-dev x11proto-xext-dev \
#  nx-x11proto-core-dev nx-x11proto-input-dev nx-x11proto-kb-dev nx-x11proto-render-dev nx-x11proto-xext-dev \

for i in \
  libudev1 libudev-dev \
  libasound2 libasound2-dev libpulse0 libpulse-dev libpulse-mainloop-glib0 \
  libx11-6 libx11-dev libxtst6 libxtst-dev libxext6 libxext-dev \
  x11proto-dev x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-render-dev x11proto-xext-dev \
  libxi6 libxi-dev libice6 libice-dev libxrender1 libxrender-dev libsm6 libsm-dev libxt6 libxt-dev \
  libxxf86vm1 libxxf86vm-dev libxinerama1 libxinerama-dev libxrandr2 libxrandr-dev libxcursor1 libxcursor-dev libxfixes3 libxfixes-dev \
  libgl1-mesa-glx libgl1-mesa-dev libglu1-mesa libglu1-mesa-dev \
  libxcb1 libxcb1-dev libxau6 libxau-dev libxdmcp6 libxdmcp-dev libbsd0 libbsd-dev \
  libfontconfig1 libfontconfig1-dev libfreetype6 libfreetype6-dev libpng16-16 libpng-dev zlib1g zlib1g-dev \
  ; \
do 
    if [ $DOWNLOAD -eq 1 ] ; then
        mkdir -p $TDIR/packs
        cd $TDIR/packs
        echo "searching for $i"
        apt-get download $i
        cd $TDIR
    fi
    mkdir -p sysroot
    for j in `find $TDIR/packs -name $i\*.deb` ; do 
        OK=1
        echo "Found $j"
        dpkg-deb -x $j sysroot
    done
    if [ $OK -eq 0 ] ; then
        echo "Not found $i"
    fi
    echo
done

# merge all usr/
mkdir -p usr/lib
cp -a sysroot/lib/aarch64-linux-gnu/* usr/lib/
cp -a sysroot/usr/lib/aarch64-linux-gnu/* usr/lib/

mkdir -p usr/include
cp -a sysroot/usr/include/* usr/include/

mkdir -p usr/share
cp -a sysroot/usr/share/* usr/share/

rm -rf sysroot
