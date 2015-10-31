#!/bin/bash

if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
exit
fi
if [ ! -d l-smash ]; then
    mkdir l-smash
fi
cd l-smash
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/l-smash/l-smash.git ./
fi
git pull -v --progress
./configure --prefix="/mingw32" --extra-cflags="-m32" --extra-ldflags="-m32"
make clean
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
make -j$THREAD && make install
