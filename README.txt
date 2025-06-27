
https://crosstool-ng.github.io/
https://github.com/crosstool-ng/crosstool-ng

+++

Distribution Compatibility Notes (Debian 11 Bullseye):
    C library       : glibc-2.31
    Binutils        : binutils-2.35.1
    Compiler        : gcc-12.4.0; static libstdc++
    Linux           : linux-5.10.233 (Debian 11: 5.10)

glibc-2.31 allows compatibility with Debian >= 11

+++

0) Install crosstool-ng 1.27.0 for building crosstools

 apt-get install help2man python3-dev

 git clone https://github.com/crosstool-ng/crosstool-ng
 cd crosstool-ng
 git checkout --track -b b_1.27.0 crosstool-ng-1.27.0
 ./bootstrap

 ./configure --prefix=/usr/local
 make
 sudo make install

1) Some local preparations

 # where the cross-tools will be build, aka cross-tools projects
 mkdir /usr/local/projects/crosstool-ng-projects ; cd /usr/local/projects/crosstool-ng-projects

 # where the cross-tools will be installed and run from
 mkdir /usr/local/x-tools

 export CT_PREFIX=/usr/local/x-tools

2) Build for armv7-unknown-linux-gnueabihf

    mkdir armv7-unknown-linux-gnueabihf ; cd armv7-unknown-linux-gnueabihf
    
    ct-ng armv7-rpi2-linux-gnueabihf 
    ct-ng menuconfig
    Target          : arm; Def Instr arm; EABI; ** Append 'hf' to tuple; 'v7' arch suffix; ** Combing Libs Single Dir; 
                      MMU; Little-Endian; 32-bit; ** TUNE armv7; FPU ''; hardware FPU **
    Toolchain       : Sysroot, 'unknown' Tuple's vendor, 

    Languages       : C,C++
    OS              : linux-5.10.233; Check Headers, build libs
    Binutils        : binutils-2.35.1
    C library       : glibc-2.31
    Compiler        : gcc-12.4.0; static libstdc++
    Debug tools     : duma-2_5_21 gdb-10.2 ltrace-0.7.3 strace-6.13
    Companion libs  : expat-2.5.0 gettext-0.21 gmp-6.2.1 isl-0.23 libiconv-1.15 mpc-1.3.1 mpfr-4.2.1 ncurses-6.2 zlib-1.2.13
    Companion tools : automake-1.16.5

    ct-ng build

3) Build for aarch64-unknown-linux-gnu

    mkdir aarch64-unknown-linux-gnu ; cd aarch64-unknown-linux-gnu
    
    ct-ng aarch64-unknown-linux-gnu
    Languages       : C,C++
    OS              : linux-5.10.233
    Binutils        : binutils-2.35.1
    C library       : glibc-2.31
    Compiler        : gcc-12.4.0; static libstdc++
    Debug tools     : gdb-10.2
    Companion libs  : expat-2.5.0 gettext-0.21 gmp-6.2.1 isl-0.23 libiconv-1.15 mpc-1.3.1 mpfr-4.2.1 ncurses-6.2 zlib-1.2.13
    Companion tools : automake-1.16.5

    ct-ng build

