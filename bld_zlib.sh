#!/bin/bash
if [ $MSYSTEM != "MINGW32" ]; then
echo "You MUST launch MSYS2 using mingw32_shell.bat"
echo "OR set the PROCESS environment variable: MSYSTEM , to 'MINGW32', prior launching mintty.exe"
exit
else
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
CFLAGS="-m32" LDFLAGS="-m32" ./configure --prefix="/mingw32" --static
THREAD=$(nproc)
THREAD=$((THREAD<2?1:THREAD-1))
make -j$THREAD all
pushd contrib/minizip > /dev/null
autoreconf -fi

CFLAGS+=" -DHAVE_BZIP2"
CFLAGS="-m32" LDFLAGS="-m32" ./configure --prefix="/mingw32" --disable-shared --enable-static LIBS="-lbz2"
make -j$THREAD
popd > /dev/null
cd ~/zlib
make install
pushd ~/zlib/contrib/minizip > /dev/null
make install
popd > /dev/null

