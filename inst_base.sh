#!/usr/bin/bash
pacman --needed --noconfirm -S mingw-w64-i686-gcc mingw-w64-i686-cmake pkg-config libtool make automake autogen autoconf bison python2 perl scons vim texinfo wget yasm patch nasm dos2unix diffutils unzip zip p7zip tar
pacman --needed --noconfirm -S git subversion mercurial

git config --global user.name "guest"
git config --global user.email guest@foobar.com