sudo apt install -y m4

# Download important files and Configure Paths:
sudo mkdir -p /usr/cross-freebsd/x86_64-unknown-freebsd13/include
suod mkdir -p /usr/cross-freebsd/x86_64-unknown-freebsd13/lib
mkdir -p ./lib32 ./base lib include
cd lib
wget -O - https://github.com/freebsd/freebsd-src/archive/main.tar.gz | tar -xz --strip=2 "freebsd-src-main/lib"
cd ../include/
wget -O - https://github.com/freebsd/freebsd-src/archive/main.tar.gz | tar -xz --strip=2 "freebsd-src-main/include"
cd ..
wget https://ftp.tw.freebsd.org/pub/FreeBSD/releases/amd64/13.0-RELEASE/base.txz
wget https://ftp.tw.freebsd.org/pub/FreeBSD/releases/amd64/13.0-RELEASE/lib32.txz
tar -xf base.txz -C ./base
tar -xf lib32.txz -C ./lib32

rm -rf base.txz lib32.txz include_lib.tar.gz
mv lib32/usr/lib32 ./base/usr/lib32/
mv lib /usr/cross-freebsd/x86_64-unknown-freebsd13/
mv include /usr/cross-freebsd/x86_64-unknown-freebsd13/

# BINUTILS:
wget https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.bz2
tar jxf binutils-2.36.tar.bz2 && rm binutils-2.36.tar.bz2
cd binutils-2.36
./configure --with-sysroot=~/freebsd-cross-compiler/base/ --enable-libssp --enable-gold --enable-ld --target=x86_64-unknown-freebsd13 --prefix=/usr/cross-freebsd
gmake
gmake install

# GMP
cd ..
wget https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.bz2
tar jxf gmp-6.2.1.tar.bz2 && rm gmp-6.2.1.tar.bz2
cd gmp-6.2.1
./configure --prefix=/usr/cross-freebsd --enable-shared --enable-static --enable-mpbsd --enable-fft --enable-cxx --host=x86_64-unknown-freebsd13
gmake
gmake install

# MPFR:
cd ..
wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.bz2
tar jxf mpfr-4.1.0.tar.bz2 && rm mpfr-4.1.0.tar.bz2
cd mpfr-4.1.0
./configure --prefix=/usr/cross-freebsd --with-gnu-ld --with-gmp=/usr/cross-freebsd --enable-static --enable-shared --host=x86_64-unknown-freebsd13
gmake
gmake install

# MPC:
cd ..
wget https://ftp.gnu.org/gnu/mpc/mpc-1.2.0.tar.gz
tar -xf mpc-1.2.0.tar.gz && rm mpc-1.2.0.tar.gz
cd mpc-1.2.0
./configure --prefix=/usr/cross-freebsd --with-gnu-ld --with-gmp=/usr/cross-freebsd --with-mpfr=/usr/cross-freebsd --enable-static --enable-shared --host=x86_64-unknown-freebsd13
gmake
gmake install

# GCC
cd ..
wget https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.gz
tar -xf gcc-11.1.0.tar.gz && rm gcc-11.1.0.tar.gz
mkdir objdir
cd objdir
../gcc-11.1.0/configure --without-headers --with-sysroot=~/freebsd-cross-compiler/base/ --with-gnu-as --with-gnu-ld --enable-languages=c,c++ --disable-nls --enable-libssp --enable-gold --enable-ld --target=x86_64-unknown-freebsd13 --prefix=/usr/cross-freebsd --with-gmp=/usr/cross-freebsd --with-mpc=/usr/cross-freebsd --with-mpfr=/usr/cross-freebsd --disable-libgomp
LD_LIBRARY_PATH=/usr/cross-freebsd/lib gmake
gmake install


# Biuld Your application:
export PATH=${PATH}:/usr/cross-freebsd/bin
export LD_LIBRARY_PATH=/usr/cross-freebsd/lib
