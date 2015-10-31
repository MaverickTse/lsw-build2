#!/bin/bash -ux
if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
exit
fi
if [ ! -d ojp152 ]; then
    mkdir ojp152
fi
cd ojp152
if [ ! -f openjpeg-1.5.2.tar.gz ]; then
    wget http://downloads.sourceforge.net/project/openjpeg.mirror/1.5.2/openjpeg-1.5.2.tar.gz -O openjpeg-1.5.2.tar.gz
    tar zxvf openjpeg-1.5.2.tar.gz --strip-components=1
	cp ~/patches/mingw-w64-openjpeg/*.patch ./
	dos2unix libopenjpeg/opj_malloc.h
	patch -p1 -t -N < cdecl.patch
    patch -p1 -t -N < openjpeg-1.5.1_tiff-pkgconfig.patch
    patch -p1 -t -N < mingw-install-pkgconfig-files.patch
    patch -p1 -t -N < versioned-dlls-mingw.patch
fi
make clean
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
cmake \
    -G"MSYS Makefiles" \
    -DCMAKE_INSTALL_PREFIX="$(cygpath -wa /)mingw32" \
	-DCMAKE_C_FLAGS=" -m32" \
	-DCMAKE_CXX_FLAGS=" -m32" \
	-DCMAKE_EXE_LINKER_FLAGS=" -m32" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING:BOOL=OFF \
    -DCMAKE_SYSTEM_PREFIX_PATH="$(cygpath -wa /)mingw32" \
    -DOPENJPEG_INSTALL_SUBDIR="openjpeg/1.5.2" \
	-DBUILD_THIRDPARTY:BOOL=ON \
    -DBUILD_MJ2=ON \
    -DBUILD_JPWL=ON \
    -DBUILD_JPIP=OFF \
	-DBUILD_SHARED_LIBS=OFF
    


make -j$THREAD && make install
