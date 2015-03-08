#!/bin/bash

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
make -j$(nproc) && make install
