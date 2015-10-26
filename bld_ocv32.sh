if [ ! -d ~/opencv ]; then
  git clone --recursive https://github.com/Itseez/opencv.git
fi
if [ ! -d ~/ocv32 ]; then
mkdir ~/ocv32
fi
cd ~/ocv32
if [ -f Makefile ]; then
make clean
fi
cd ~/opencv
git pull
cp ~/patches/mingw-w64-opencv/*.patch ./
patch -Np1 -i "mingw-w64-cmake.patch"
patch -Np1 -i "solve_deg3-underflow.patch"
patch -Np1 -i "issue-4107.patch"
patch -Np1 -i "remove-bindings-generation-DetectionBasedTracker.patch"
patch -Np1 -i "generate-proper-pkg-config-file.patch"
patch -Np1 -i "opencv-support-python-3.5.patch"
cd ~/ocv32
PATH=${PATH}:${CUDA_PATH}
cmake \
    -G"MSYS Makefiles" \
	-DCMAKE_C_FLAGS=" -m32" \
	-DCMAKE_CXX_FLAGS=" -m32" \
	-DCMAKE_EXE_LINKER_FLAGS=" -m32" \
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
	-Wno-dev \
	~/opencv \

make -j$(nproc) && make package