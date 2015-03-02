#!/bin/bash -ux
if [ ! -d ojp152 ]; then
    mkdir ojp152
fi
cd ojp152
if [ ! -f openjpeg-1.5.2.tar.gz ]; then
    wget http://downloads.sourceforge.net/project/openjpeg.mirror/1.5.2/openjpeg-1.5.2.tar.gz -O openjpeg-1.5.2.tar.gz
    tar zxvf openjpeg-1.5.2.tar.gz --strip-components=1
	cp ~/patches/mingw-w64-openjpeg/*.patch ./
	dos2unix libopenjpeg/opj_malloc.h
	patch -Np1 < cdecl.patch
    patch -Np1 < openjpeg-1.5.1_tiff-pkgconfig.patch
    patch -Np1 < mingw-install-pkgconfig-files.patch
    patch -Np1 < versioned-dlls-mingw.patch
fi

/mingw32/bin/cmake \
    -G"MSYS Makefiles" \
    -DCMAKE_INSTALL_PREFIX="$(cygpath -wa /)mingw32" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING:BOOL=OFF \
    -DCMAKE_SYSTEM_PREFIX_PATH="$(cygpath -wa /)\mingw32" \
    -DOPENJPEG_INSTALL_SUBDIR="openjpeg/1.5.2" \
	-DBUILD_THIRDPARTY:BOOL=ON \
    -DBUILD_MJ2=ON \
    -DBUILD_JPWL=ON \
    -DBUILD_JPIP=OFF \
	-DBUILD_SHARED_LIBS=OFF
    

make clean
make -j$(nproc)
make install
