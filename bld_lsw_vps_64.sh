#!/bin/bash

if [ ! -d LSW_64 ]; then
    mkdir LSW_64
fi
cd LSW_64
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/VFR-maniac/L-SMASH-Works.git ./
fi
git pull -v --progress
cd VapourSynth
./configure --prefix="/mingw64" --extra-ldflags="-static"
make clean
make -j$(nproc) && make install

