#!/bin/bash
if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
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
if [ ! -d ff32 ]; then
	mkdir ff32
else
	rm -rd ff32
	mkdir ff32
fi
cd ff32

~/ffmpeg/configure --prefix="/mingw32" --target-os=mingw32 \
  --extra-cflags="-m32 -fexcess-precision=fast -I/mingw32/include/openjpeg-1.5" \
  --extra-ldflags="-m32" \
  --enable-static --enable-avresample --enable-memalign-hack \
  --enable-pthreads --enable-runtime-cpudetect --enable-gpl \
  --enable-version3 --enable-libopus --enable-libopenjpeg \
  --enable-avisynth --disable-doc --disable-debug \
  --disable-network --disable-shared --disable-w32threads
make clean
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
make -j$THREAD && make install
