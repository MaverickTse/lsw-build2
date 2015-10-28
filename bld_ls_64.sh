#!/bin/bash

if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
else
if [ ! -d l-smash_64 ]; then
    mkdir l-smash_64
fi
cd l-smash_64
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/l-smash/l-smash.git ./
fi
git pull -v --progress
./configure --prefix="/mingw64" --extra-cflags="-static"
make clean
make -j$(nproc) && make install
