#!/bin/bash
if [ $MSYSTEM != "MINGW64" ]; then
echo "You MUST launch MSYS2 using mingw64_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW64', prior launching mintty.exe"
exit
else
if [ ! -d zlib_64 ]; then
    mkdir zlib_64
fi
cd ~/zlib_64
if [ ! -f zlib-1.2.8.tar.gz ]; then
    wget http://zlib.net/zlib-1.2.8.tar.gz -O zlib-1.2.8.tar.gz
    tar zxvf zlib-1.2.8.tar.gz --strip-components=1
	cd contrib
	rm -r -d minizip
	mkdir minizip
	
fi
cd ~/zlib_64/contrib/minizip
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false git://github.com/nmoinvaz/minizip.git ./
	if [ "$?" != "0" ]; then
	  git clone -v --progress --config core.autocrlf=false https://github.com/nmoinvaz/minizip.git ./
	fi
fi
git pull -v --progress
cd ../../
cp ~/patches/mingw-w64-zlib/*.patch ./
patch -p2 -t -N < 01-zlib-1.2.7-1-buildsys.mingw.patch
patch -p2 -t -N < 03-dont-put-sodir-into-L.mingw.patch
patch -p2 -t -N < 013-fix-largefile-support.patch
cd contrib/minizip
git apply ../../010-unzip-add-function-unzOpenBuffer.patch
git apply ../../011-Add-no-undefined-to-link-to-enable-build-shared-vers.patch
git apply ../../012-Add-bzip2-library-to-pkg-config-file.patch

cd ../../
CFLAGS="-static" ./configure --prefix="/mingw64" --static
make -j$(nproc) all
pushd contrib/minizip > /dev/null
autoreconf -fi

CFLAGS+=" -DHAVE_BZIP2"
./configure --prefix="/mingw64" --disable-shared --enable-static LIBS="-lbz2"
make -j$(nproc)
popd > /dev/null
cd ~/zlib_64
make install
pushd ~/zlib/contrib/minizip > /dev/null
make install
popd > /dev/null

