#!/usr/bin/bash -be
if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
exit
else
echo -e "\E[30;42m Downloading Patch files from MSYS2 Project(GitHub)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./get_patch.sh
echo -e "\E[30;42m Building BZip2\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_bzip2.sh
echo -e "\E[30;42m Building zlib\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_zlib.sh
echo -e "\E[30;42m Building OpenJpeg 1.5\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_ojp152.sh
echo -e "\E[30;42m Building libOpus (Git)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_opus.sh
echo -e "\E[30;42m Building L-Smash (GitHub)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_ls.sh
echo -e "\E[30;42m Building static FFmpeg+opus+openjpeg (GitHub)\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_ffmpeg.sh
echo -e "\E[30;42m Building L-Smash Works Plugins for AviUtl\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_lsw_aviutl.sh
echo -e "\E[30;42m Building L-Smash Works Plugin for VapourSynth\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./bld_lsw_vps.sh
echo -e "\E[32;40m Packaging...\E[0m"
tput sgr0 # Reset text attributes to normal without clear
./packaging.sh
echo -e "\E[37;40m DONE!\E[0m"
tput sgr0 # Reset text attributes to normal without clear
fi
