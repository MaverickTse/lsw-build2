#!/bin/bash

if [ ! -d opus_64 ]; then
    mkdir opus_64
fi
cd opus_64
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false git://git.opus-codec.org/opus.git ./
	
fi
git pull -v --progress
cp ~/patches/mingw-w64-opus/*.patch ./
patch -p1 -t -N < 0001-correctly-detect-alloca.mingw.patch
autoreconf -fi
./configure --prefix="/mingw64" --enable-static --disable-shared --enable-custom-modes
make clean
make -j$(nproc) && make install
