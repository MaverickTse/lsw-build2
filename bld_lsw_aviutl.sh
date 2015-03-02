#!/bin/bash

if [ ! -d LSW ]; then
    mkdir LSW
fi
cd LSW
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/VFR-maniac/L-SMASH-Works.git ./
fi
git pull -v --progress
cd AviUtl
./configure --prefix="/mingw32" --extra-ldflags="-static"
make clean
make -j$(nproc)

