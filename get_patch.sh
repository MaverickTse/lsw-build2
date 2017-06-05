#!/bin/bash -eux
cd ~
if [ ! -d patches ]; then
    mkdir patches
fi
cd patches
if [ ! -d .git ]; then
    git clone -v --depth=1 --progress --config core.autocrlf=false https://github.com/Alexpux/MINGW-packages.git ./
fi
git pull -v --progress
cd ~