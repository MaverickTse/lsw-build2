#!/bin/bash

if [ ! -d opus ]; then
    mkdir opus
fi
cd opus
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false http://git.opus-codec.org/opus.git ./
	
fi
git pull -v --progress
cp ~/patches/mingw-w64-opus/*.patch ./
patch -p1 -t -N < 0001-correctly-detect-alloca.mingw.patch
autoreconf -fi
./configure --prefix="/mingw32" --enable-static --disable-shared --enable-custom-modes
make clean
make -j$(nproc) && make install
