#!/usr/bin/bash -be
if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
else
echo -e "\E[30;42m Downloading Patch files from MSYS2 Project(GitHub)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./get_patch.sh
echo -e "\E[30;42m Building BZip2\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_bzip2_64.sh
echo -e "\E[30;42m Building zlib\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_zlib_64.sh
echo -e "\E[30;42m Building OpenJpeg 1.5\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_ojp152_64.sh
echo -e "\E[30;42m Building libOpus (Git)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_opus_64.sh
echo -e "\E[30;42m Building L-Smash (GitHub)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_ls_64.sh
echo -e "\E[30;42m Building static FFmpeg+opus+openjpeg (GitHub)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_ffmpeg_64.sh
echo -e "\E[30;42m Building L-Smash Works Plugin for VapourSynth\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_lsw_vps_64.sh
echo -e "\E[32;40m Packaging...\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./packaging_64.sh
echo -e "\E[37;40m DONE!\E[0m"
tput sgr0 # Reset text attributes to normal without clear
fi
