#!/bin/bash

if [ ! -d ffmpeg ]; then
    mkdir ffmpeg
fi
cd ffmpeg
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false https://github.com/FFmpeg/FFmpeg.git ./
fi
git pull -v --progress
./configure --prefix="/mingw32" --target-os=mingw32 \
  --extra-cflags="-m32 -fexcess-precision=fast -I/mingw32/include/openjpeg-1.5" \
  --extra-ldflags="-m32" \
  --enable-static --enable-avresample --enable-memalign-hack \
  --enable-pthreads --enable-runtime-cpudetect --enable-gpl \
  --enable-version3 --enable-libopus --enable-libopenjpeg \
  --enable-avisynth --disable-doc --disable-debug \
  --disable-network --disable-shared --disable-w32threads
make clean
make -j$(nproc) && make install
