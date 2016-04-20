#!/usr/bin/bash
#pacman -Sy
#pacman --needed --noconfirm -S bash pacman pacman-mirrors msys2-runtime
#update-core #obsoleted as MSYS2 pacman package ver 5
#Note that it is not the version of pacman itself, just the MSYS2 PACKAGE version!
#first check the LOCAL pacman package version. If major version <=4, run core-update, pacman -Syuu otherwise
pacman_ver=$(pacman -Q -s 'pacman'|head -1|egrep -o '[[:digit:]]{1}'|head -1)
if [ ${pacman_ver} -le 4 ]; then
update-core
else
pacman -Syuu
fi
#MSYS2 should be closed here without calling EXIT
