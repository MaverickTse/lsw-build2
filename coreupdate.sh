#!/usr/bin/bash
#pacman -Sy
#pacman --needed --noconfirm -S bash pacman pacman-mirrors msys2-runtime
#update-core #obsoleted as MSYS2 pacman package ver 5
#Note that it is not the version of pacman itself, just the MSYS2 PACKAGE version!
#first check the LOCAL pacman package version. If major version <=4, run core-update, pacman -Syuu otherwise
pacman_ver_str=$(pacman -Q -s 'pacman'|head -1|grep -P -o '\d+\.\d+\.\d+\.\d+')
#the version string above has 4 numbers
IFS='.' ver_array=($pacman_ver_str)
#check if under 5.0.1.6403
if [ ${ver_array[0]} -le 4 ]; then
update-core
elif [ ${ver_array[0]} -eq 5 ] && [ ${ver_array[1]} -eq 0 ] && [ ${ver_array[2]} -eq 0 ]; then
#5.0.0 -> old
update-core
elif [ ${ver_array[0]} -eq 5 ] && [ ${ver_array[1]} -eq 0 ] && [ ${ver_array[2]} -eq 1 ] && [ ${ver_array[3]} -lt 6403 ]; then
#5.0.1.<6403 -> old
update-core
else
pacman -Syuu
#Syuu is recommended by the official MSYS2 wiki: upgrad+downgrade
fi
