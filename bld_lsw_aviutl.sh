#!/bin/bash

if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
exit
else
if [ ! -d LSW ]; then
    mkdir LSW
fi
cd LSW
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/VFR-maniac/L-SMASH-Works.git ./
fi
git pull -v --progress
#cd /mingw32/bin
#mv ./gcc ./gcc32
#mv ./gcc64.exe ./gcc.exe
#mv ./ld ./ld32
#mv ./ld64.exe ./ld.exe
cd ~/LSW/AviUtl
sed 's/^RCFLAGS.*/RCFLAGS = -J rc -O coff --target=pe-i386/' < ./GNUmakefile > ./GNUmakefile32
mv ./GNUmakefile ./GNUmakefile_original
mv ./GNUmakefile32 ./GNUmakefile
./configure --extra-cflags=" -m32 " --extra-ldflags=" -m32 " 
make clean
make -j$(nproc)
rm ./GNUmakefile
mv ./GNUmakefile_original ./GNUmakefile
#cd /mingw32/bin
#mv ./gcc.exe ./gcc64.exe
#mv ./gcc32 ./gcc
#mv ./ld.exe ./ld64.exe
#mv ./ld32 ./ld
cd ~