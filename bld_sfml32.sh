if [ ! -d ~/sfml ]; then
  git clone --recursive https://github.com/SFML/SFML.git sfml
else
  cd sfml
  git pull  
fi
cd ~
if [ ! -d ~/sfml32 ]; then
mkdir ~/sfml32
fi
cd ~/sfml32
if [ -f Makefile ]; then
make clean
fi
cd ~/sfml32
cmake \
    -G"MSYS Makefiles" \
	-DCMAKE_C_FLAGS=" -m32" \
	-DCMAKE_CXX_FLAGS=" -m32" \
	-DCMAKE_EXE_LINKER_FLAGS=" -m32" \
    -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=${MINGW_PREFIX} \
    -DSFML_BUILD_EXAMPLES=ON \
    -DSFML_BUILD_DOC=OFF \
    -DSFML_INSTALL_PKGCONFIG_FILES=OFF \
	-DSFML_USE_STATIC_STD_LIBS=ON \
	-DBUILD_SHARED_LIBS=OFF \
	${HOME}/sfml \

make -j$(nproc)