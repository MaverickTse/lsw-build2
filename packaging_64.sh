#!/bin/bash

if [ ! -d /ReadyToUse64 ]; then
    mkdir /ReadyToUse64
fi
cd /ReadyToUse64
echo "Copying L-Smash EXE..."

if [ -f /mingw64/bin/muxer.exe ]; then
cp /mingw64/bin/muxer.exe \
 /mingw64/bin/remuxer.exe \
 /mingw64/bin/timelineeditor.exe \
 /mingw64/bin/boxdumper.exe \
  ./
fi
  
if [ -f muxer.exe ]; then  
echo "Packing up L-Smash files..."  
7z a -y -t7z -m0=lzma2 -mx=9 -ms=on L-Smash_win64_$(date +'%Y%m%d').7z *.exe
fi

echo "Copying L-Smash Works for VapourSynth (.DLL) ..."

if [ -f ~/LSW_64/VapourSynth/vslsmashsource.dll ]; then
cp ~/LSW_64/VapourSynth/*.dll ./
echo "Packing up VapourSynth Plugins..."
7z a -y -t7z -m0=lzma2 -mx=9 -ms=on L-Smash_Works_VapourSynth_win64_$(date +'%Y%m%d').7z vslsmashsource.dll ~/LSW_64/VapourSynth/README ~/LSW_64/VapourSynth/LICENSE
fi

echo "Build finished and output files can be found at:"
echo $(cygpath -wa /ReadyToUse64)
echo
echo "Current folder content:"
ls

