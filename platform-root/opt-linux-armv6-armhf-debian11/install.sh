#! /bin/bash

DOWNLOAD=1

ARCHITECTURE=armv6
TARGET_DEFAULT=bullseye
TARGET_BACKPORT=bullseye-backports

TDIR=`pwd`

set -o pipefail

trap_exit_report() {
    echo "Trap: Exit on line $(caller)"
}

trap_err_report() {
    echo "Trap: Error on line $(caller); exit"
    exit 1
}

trap 'trap_exit_report $LINENO' EXIT
trap 'trap_err_report $LINENO' ERR

rm -rf usr
rm -rf sysroot
if [ $DOWNLOAD -eq 1 ] ; then
    rm -rf packs
fi

mkdir -p packs
mkdir -p sysroot

#  x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-render-dev x11proto-xext-dev \
#  nx-x11proto-core-dev nx-x11proto-input-dev nx-x11proto-kb-dev nx-x11proto-render-dev nx-x11proto-xext-dev \

PACKAGES_DEFAULT="\
  libdbus-1-3 libdbus-1-dev libudev1 libudev-dev \
  libpulse0 libpulse-dev libpulse-mainloop-glib0 \
  libsndio7.0 libsndio-dev \
  libsndfile1 libsndfile1-dev \
  libasound2 libasound2-dev \
  libdrm2 libdrm-dev libgbm1 libgbm-dev \
  libx11-6 libx11-dev libxtst6 libxtst-dev libxext6 libxext-dev \
  x11proto-dev x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-render-dev x11proto-xext-dev \
  libxi6 libxi-dev libice6 libice-dev libxrender1 libxrender-dev libsm6 libsm-dev libxt6 libxt-dev \
  libxxf86vm1 libxxf86vm-dev libxinerama1 libxinerama-dev libxrandr2 libxrandr-dev libxcursor1 libxcursor-dev libxfixes3 libxfixes-dev \
  libgl1-mesa-glx libgl1-mesa-dev libglu1-mesa libglu1-mesa-dev \
  libxcb1 libxcb1-dev libxau6 libxau-dev libxdmcp6 libxdmcp-dev libbsd0 libbsd-dev \
  libfontconfig1 libfontconfig1-dev libfreetype6 libfreetype6-dev libpng16-16 libpng-dev zlib1g zlib1g-dev \
  openjdk-11-jre-headless openjdk-11-jre \
  libgl1 libgles1 libgles2 \
  libgl-dev libgles-dev \
  libsdl2-2.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0 \
  libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-mixer-dev \
  libunwind8 libunwind-dev \
  "

PACKAGES_BACKPORT="\
  libspa-0.2-modules libspa-0.2-dev libpipewire-0.3-0 libpipewire-0.3-dev"

if [ $DOWNLOAD -eq 1 ] ; then
    cd $TDIR/packs
    for i in $PACKAGES_DEFAULT ; do 
        echo "searching for $i"
        apt-get -t=$TARGET_DEFAULT download $i
        ploc=`find $TDIR/packs -name $i\*.deb`
        if [ -z "$ploc" ] ; then
            echo "Not downloaded $i"
            exit 1
        fi
    done
    for i in $PACKAGES_BACKPORT ; do 
        echo "searching for $i"
        apt-get -t=$TARGET_BACKPORT download $i
        ploc=`find $TDIR/packs -name $i\*.deb`
        if [ -z "$ploc" ] ; then
            echo "Not downloaded $i"
            exit 1
        fi
    done
    cd $TDIR
fi

for i in $PACKAGES_DEFAULT $PACKAGES_BACKPORT ; do 
    OK=0
    for j in `find $TDIR/packs -name $i\*.deb` ; do 
        OK=1
        echo "Found $j"
        dpkg-deb -x $j sysroot
    done
    if [ $OK -eq 0 ] ; then
        echo "Not found $i"
        exit 1
    fi
    echo
done

# merge all usr/
mkdir -p usr/lib
cp -a sysroot/lib/arm-linux-gnueabihf/* usr/lib/
cp -a sysroot/usr/lib/arm-linux-gnueabihf/* usr/lib/
cd $TDIR/usr/lib
ln -s . arm-linux-gnueabihf
cd $TDIR

mkdir -p usr/include
cp -a sysroot/usr/include/* usr/include/

mkdir -p usr/share
cp -a sysroot/usr/share/* usr/share/

# Remove SDL2 undesired artifacts
rm -rf usr/lib/installed-tests

mkdir -p jre/lib/arm
cp -a sysroot/usr/lib/jvm/java-11-openjdk-armhf/lib/libjava.so jre/lib/arm/
cp -a sysroot/usr/lib/jvm/java-11-openjdk-armhf/lib/libjawt.so jre/lib/arm/
cp -a sysroot/usr/lib/jvm/java-11-openjdk-armhf/lib/libawt*.so jre/lib/arm/
cp -a sysroot/usr/lib/jvm/java-11-openjdk-armhf/lib/server     jre/lib/arm/

echo "Completed"
echo "Removed directory sysroot"
# rm -rf sysroot

