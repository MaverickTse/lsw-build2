#!/usr/bin/bash
if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
fi
if [ -f "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" ]; then
    vspath="C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
	toolset="14"
elif [ -f "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat" ]; then
    vspath="C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat"
	toolset="12"
elif [ -f "C:\Program Files\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat" ]; then
    vspath="C:\Program Files\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat"
	toolset="14"
elif [ -f "C:\Program Files\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat" ]; then
    vspath="C:\Program Files\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat"
	toolset="12"
else
	exit
fi

gccver=$(gcc --version | grep ^gcc | sed 's/^.* //g')

cd ~/LSW_64/AviSynth
cat > "bld_lsw_avs64.bat" << EOF
@echo off
chcp 1252
call "${vspath}"
if not exist UpgradeLog.htm devenv LSMASHSourceVCX.sln /upgrade
set CL= /I$(cygpath -was /mingw64/include)
set LINK="libstdc++.a" "libwinpthread.dll.a" "libopenjpeg.a" "libopus.a" "libswresample.a" /LIBPATH:$(cygpath -was /mingw64/lib) /LIBPATH:$(cygpath -was /mingw64/x86_64-w64-mingw32/lib) /LIBPATH:$(cygpath -was /mingw64/lib/gcc/x86_64-w64-mingw32/${gccver})
msbuild.exe LSMASHSourceVCX.sln /target:Rebuild /p:Configuration=Release;Platform="x64";PlatformToolset=v${toolset}0
chcp 65001
EOF

$COMSPEC /c bld_lsw_avs64.bat

cd ~
if [ -f ~/LSW_64/AviSynth/x64/Release/LSMASHSource.dll ]; then
cd ~/LSW_64/AviSynth/x64/Release/
cp LSMASHSource.dll /ReadyToUse64/
cd ../../
cp README /ReadyToUse64/
cp LICENSE /ReadyToUse64/
cp /mingw64/bin/libwinpthread_64-1.dll /ReadyToUse64/
cd /ReadyToUse64
7z a -y -t7z -m0=lzma2 -mx=9 -ms=on L-Smash_Works_AviSynth_win64_$(date +'%Y%m%d').7z LSMASHSource.dll LICENSE README libwinpthread-1.dll
ls

echo -e "\E[36;40m DONE!\E[0m"
tput sgr0 # Reset text attributes to normal without clear
else
echo "Failed to build L-Smash_Works_AviSynth_win64"
fi
