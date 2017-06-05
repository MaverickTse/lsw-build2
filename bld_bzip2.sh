#!/bin/bash
if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
exit
fi

if [ ! -d bzip2 ]; then
    mkdir bzip2
fi
cd bzip2
if [ ! -f bzip2-1.0.6.tar.gz ]; then
    wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz -O bzip2-1.0.6.tar.gz
    tar zxvf bzip2-1.0.6.tar.gz --strip-components=1
	cp ~/patches/mingw-w64-bzip2/*.patch ./
  	patch -p1 -t -N < bzip2-1.0.4-bzip2recover.patch
    patch -p1 -t -N < bzip2-1.0.5-slash.patch
    patch -p1 -t -N < bzgrep-debian-1.0.5-6.all.patch
    patch -p1 -t -N < bzip2-cygming-1.0.6.src.all.patch
    patch -p1 -t -N < bzip2-buildsystem.all.patch
    patch -p1 -t -N < bzip2-1.0.6-progress.all.patch
    patch -p1 -t -N < bzip2-1.0.6-fix-heap-use-after-free-bzip2recover.patch
	autoreconf -fi
fi
CFLAGS="-m32" LDFLAGS="-m32" ./configure --prefix="/mingw32"
make clean
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
make -j$THREAD && make install
