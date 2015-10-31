#!/bin/bash
if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
fi

if [ ! -d ffmpeg ]; then
    mkdir ffmpeg
fi
cd ffmpeg
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/FFmpeg/FFmpeg.git ./
else
	git pull -v --progress
fi

cd ~
if [ ! -d ff64 ]; then
	mkdir ff64
else
	rm -rd ff64
	mkdir ff64
fi
cd ff64

~/ffmpeg/configure --prefix="/mingw64" --target-os=mingw32\
  --extra-cflags="-fexcess-precision=fast -I/mingw64/include/openjpeg-1.5" \
  --enable-static --enable-avresample --enable-memalign-hack \
  --enable-pthreads --enable-runtime-cpudetect --enable-gpl \
  --enable-version3 --enable-libopus --enable-libopenjpeg \
  --enable-avisynth --disable-doc --disable-debug \
  --disable-network --disable-shared --disable-w32threads
make clean
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
make -j$THREAD && make install
