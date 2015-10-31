#!/bin/bash
if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
fi
if [ ! -d ~/opencv ]; then
  git clone --recursive https://github.com/Itseez/opencv.git
else
  cd opencv
  git pull  
fi
cd ~
if [ ! -d ~/ocvcontrib ]; then
  git clone --recursive https://github.com/Itseez/opencv_contrib.git ocvcontrib
else
  cd ocvcontrib
  git pull
fi
cd ~
if [ ! -d ~/ocv64 ]; then
mkdir ~/ocv64
fi
cd ~/ocv64
if [ -f Makefile ]; then
make clean
fi

cd ~/opencv

cp ~/patches/mingw-w64-opencv/*.patch ./
patch -Np1 -i "mingw-w64-cmake.patch"
patch -Np1 -i "solve_deg3-underflow.patch"
#patch -Np1 -i "issue-4107.patch"
#4107 should have been fixed in master branch
patch -Np1 -i "remove-bindings-generation-DetectionBasedTracker.patch"
patch -Np1 -i "generate-proper-pkg-config-file.patch"
patch -Np1 -i "opencv-support-python-3.5.patch"
cd ~/ocv64
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
PATH=${PATH}:${CUDA_PATH}
cmake \
    -G"MSYS Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
	-DPKG_CONFIG_WITHOUT_PREFIX=ON \
	-DBUILD_SHARED_LIBS=ON \
	-DWITH_CUDA=OFF \
	-DWITH_VTK=OFF \
	-DWITH_GTK=OFF \
    -DWITH_OPENCL=ON \
    -DWITH_OPENGL=ON \
	-DCMAKE_SKIP_RPATH=ON \
    -DENABLE_PRECOMPILED_HEADERS=OFF \
    -DENABLE_FAST_MATH=ON \
	-DENABLE_SSE3=ON \
	-DENABLE_SSSE3=ON \
	-DENABLE_SSE41=ON \
	-DENABLE_SSE42=ON \
	-DCPACK_BINARY_7Z=ON \
	-DCPACK_BINARY_NSIS=OFF \
	-DOPENCV_EXTRA_MODULES_PATH=../ocvcontrib/modules \
	-DBUILD_opencv_text=OFF \
	-Wno-dev \
	~/opencv \

make -j$THREAD && make package