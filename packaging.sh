#!/bin/bash

if [ ! -d /ReadyToUse32 ]; then
    mkdir /ReadyToUse32
fi
cd /ReadyToUse32

if [ -f /mingw32/bin/muxer.exe ]; then
echo "Copying L-Smash EXE..."

cp /mingw32/bin/muxer.exe \
 /mingw32/bin/remuxer.exe \
 /mingw32/bin/timelineeditor.exe \
 /mingw32/bin/boxdumper.exe \
  ./
echo "Packing up L-Smash files..."  
7z a -y -t7z -m0=lzma2 -mx=9 -ms=on L-Smash_win32_$(date +'%Y%m%d').7z *.exe
fi

if [ -f ~/LSW/AviUtl/lwinput.aui ]; then
echo "Copying L-Smash Works for AviUtl (.AU?) ..."
cp ~/LSW/AviUtl/*.au? ./
echo "Packing up AviUtl Plugins..."
7z a -y -t7z -m0=lzma2 -mx=9 -ms=on L-Smash_Works_AviUtl_$(date +'%Y%m%d').7z *.au? ~/LSW/AviUtl/README ~/LSW/AviUtl/LICENSE
fi

if [ -f ~/LSW/VapourSynth/vslsmashsource.dll ]; then
echo "Copying L-Smash Works for VapourSynth (.DLL) ..."
cp ~/LSW/VapourSynth/*.dll ./
echo "Packing up VapourSynth Plugins..."
7z a -y -t7z -m0=lzma2 -mx=9 -ms=on L-Smash_Works_VapourSynth_win32_$(date +'%Y%m%d').7z *.dll ~/LSW/VapourSynth/README ~/LSW/VapourSynth/LICENSE
fi

echo "Build finished and output files can be found at:"
echo $(cygpath -wa /ReadyToUse32)
echo
echo "Current folder content:"
ls

