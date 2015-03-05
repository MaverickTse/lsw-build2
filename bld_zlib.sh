#!/bin/bash
if [ ! -d zlib ]; then
    mkdir zlib
fi
cd ~/zlib
if [ ! -f zlib-1.2.8.tar.gz ]; then
    wget http://zlib.net/zlib-1.2.8.tar.gz -O zlib-1.2.8.tar.gz
    tar zxvf zlib-1.2.8.tar.gz --strip-components=1
	cd contrib
	rm -r -d minizip
	mkdir minizip
	
fi
cd ~/zlib/contrib/minizip
if [ ! -d .git ]; then
    git clone -v --progress --config core.autocrlf=false git://github.com/nmoinvaz/minizip.git ./
fi
git pull -v --progress
cd ../../
cp ~/patches/mingw-w64-zlib/*.patch ./
patch -p2 -t -N < 01-zlib-1.2.7-1-buildsys.mingw.patch
patch -p2 -t -N < 03-dont-put-sodir-into-L.mingw.patch
cd contrib/minizip
git am ../../010-unzip-add-function-unzOpenBuffer.patch
git am ../../011-Add-no-undefined-to-link-to-enable-build-shared-vers.patch
git am ../../012-Add-bzip2-library-to-pkg-config-file.patch

cd ../../
CFLAGS="-static" ./configure --prefix="/mingw32" --static
make -j$(nproc) all
pushd contrib/minizip > /dev/null
autoreconf -fi

CFLAGS+=" -DHAVE_BZIP2"
./configure --prefix="/mingw32" --disable-shared --enable-static LIBS="-lbz2"
make -j$(nproc)
popd > /dev/null
cd ~/zlib
make install
pushd ~/zlib/contrib/minizip > /dev/null
make install
popd > /dev/null

