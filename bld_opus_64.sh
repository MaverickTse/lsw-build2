#!/bin/bash
if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
fi
if [ ! -d opus_64 ]; then
    mkdir opus_64
fi
cd opus_64
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false git://git.opus-codec.org/opus.git ./
	if [ "$?" != "0" ]; then
	  git clone -v --progress --config core.autocrlf=false http://git.opus-codec.org/opus.git ./
	fi
fi
git pull -v --progress
cp ~/patches/mingw-w64-opus/*.patch ./
patch -p1 -t -N < 0001-correctly-detect-alloca.mingw.patch
autoreconf -fi
./configure --prefix="/mingw64" --enable-static --disable-shared --enable-custom-modes
make clean
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
make -j$THREAD && make install
