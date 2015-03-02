#!/usr/bin/bash -be
echo -e "\E[30;42m Downloading Patch files from MSYS2 Project(GitHub)"
tput sgr0 # Reset text attributes to normal without clear
./get_patch.sh
echo -e "\E[30;42m Building BZip2"
tput sgr0 # Reset text attributes to normal without clear
./bld_bzip2.sh
echo -e "\E[30;42m Building zlib"
tput sgr0 # Reset text attributes to normal without clear
./bld_zlib.sh
echo -e "\E[30;42m Building OpenJpeg 1.5"
tput sgr0 # Reset text attributes to normal without clear
./bld_ojp152.sh
echo -e "\E[30;42m Building libOpus (Git)"
tput sgr0 # Reset text attributes to normal without clear
./bld_opus.sh
echo -e "\E[30;42m Building L-Smash (GitHub)"
tput sgr0 # Reset text attributes to normal without clear
./bld_ls.sh
echo -e "\E[30;42m Building static FFmpeg+opus+openjpeg (GitHub)"
tput sgr0 # Reset text attributes to normal without clear
./bld_ffmpeg.sh
echo -e "\E[30;42m Building L-Smash Works Plugins for AviUtl"
tput sgr0 # Reset text attributes to normal without clear
./bld_lsw_aviutl.sh
echo -e "\E[30;42m Building L-Smash Works Plugin for VapourSynth"
tput sgr0 # Reset text attributes to normal without clear
./bld_lsw_vps.sh
echo -e "\E[32;40m Packaging..."
tput sgr0 # Reset text attributes to normal without clear
./packaging.sh
echo -e "\E[37;40m DONE!"
tput sgr0 # Reset text attributes to normal without clear