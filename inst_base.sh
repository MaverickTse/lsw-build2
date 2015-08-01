#!/usr/bin/bash

pacman --needed --noconfirm -S pkg-config libtool make automake autogen autoconf bison scons vim texinfo wget yasm patch nasm dos2unix diffutils unzip zip p7zip tar git rsync

if [ $? -ne 0 ]; then
echo "Error in first pacman run, retry..."
pacman --needed --noconfirm -S pkg-config libtool make automake autogen autoconf bison scons vim texinfo wget yasm patch nasm dos2unix diffutils unzip zip p7zip tar git rsync
fi

if [ $? -ne 0 ]; then
echo "Script terminated due to pacman failing twice in a row"
echo "please retry later or check Internet connection"
exit
fi

git config --global user.name "guest"
git config --global user.email guest@foobar.com

if [ ! -d TDM ]; then
mkdir TDM
fi
cd TDM
rm *.tar.lzma
wget http://tdm-gcc.tdragon.net/download -O tdmdlpage.html

if [ $? -ne 0 ]; then
echo "Script terminated because TDM-GCC website is inaccessible"
echo "please retry later"
exit
fi

#tdm_core_url=$(grep -m 1 "tdm64.*core.tar.lzma" tdmdlpage.html | sed -r 's/.*(http.*download)">.*/\1/')
tdm_core_url=http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%204.9%20series/4.9.2-tdm64-1/gcc-4.9.2-tdm64-1-core.tar.lzma/download
#tdm_bin_url=$(grep -m 1 "binutils.*tdm64.*.tar.lzma" tdmdlpage.html | sed -r 's/.*(http.*download)">.*/\1/')
tdm_bin_url=http://sourceforge.net/projects/tdm-gcc/files/GNU%20binutils/binutils-2.25-tdm64-1.tar.lzma/download
#tdm_rt_url=$(grep -m 1 "mingw64runtime.*tdm64.*.tar.lzma" tdmdlpage.html | sed -r 's/.*(http.*download)">.*/\1/')
tdm_rt_url=http://sourceforge.net/projects/tdm-gcc/files/MinGW-w64%20runtime/GCC%204.9%20series/mingw64runtime-v3-git20141130-gcc49-tdm64-1.tar.lzma/download
#tdm_cpp_url=$(grep -m 1 "tdm64.*c++.*tar.lzma" tdmdlpage.html | sed -r 's/.*(http.*download)">.*/\1/')
tdm_cpp_url=http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%204.9%20series/4.9.2-tdm64-1/gcc-4.9.2-tdm64-1-c%2B%2B.tar.lzma/download
#tdm_omp_url=$(grep -m 1 "tdm64.*openmp.*tar.lzma" tdmdlpage.html | sed -r 's/.*(http.*download)">.*/\1/')
tdm_omp_url=http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%204.9%20series/4.9.2-tdm64-1/gcc-4.9.2-tdm64-1-openmp.tar.lzma/download
echo "downloading TDM GCC Core"
wget $tdm_core_url -O core.tar.lzma

echo "downloading TDM GCC Binutils"
wget $tdm_bin_url -O binutils.tar.lzma

echo "downloading TDM GCC Runtime libs"
wget $tdm_rt_url -O runtime.tar.lzma

echo "downloading TDM GCC C++ libs"
wget $tdm_cpp_url -O cpp.tar.lzma

echo "downloading TDM GCC OpenMP support"
wget $tdm_omp_url -O openmp.tar.lzma

echo "Extracting archives"
tar --lzma -xvf core.tar.lzma
tar --lzma -xvf binutils.tar.lzma
tar --lzma -xvf runtime.tar.lzma
tar --lzma -xvf cpp.tar.lzma
tar --lzma -xvf openmp.tar.lzma

echo "Deleting archives"
rm *.tar.lzma

echo "copying to mingw32 folder"
cd ~
rsync -a ~/TDM/ /mingw32/
echo "copying to mingw64 folder"
rsync -a ~/TDM/ /mingw64/
#Remove temp TDM files
cd ~
rm -r -d TDM


#Install Cmake
cd ~
if [ ! -d cmake ]; then
mkdir cmake
fi
cd cmake
wget http://www.cmake.org/download/ -O cmdlpage.html

cmake_url=$(grep -m 1 "cmake-[0-9.-]*win32-x86.zip" cmdlpage.html | sed -r 's/.*(http.*zip)">.*/\1/')

cmake_ver=$(grep -m 1 "cmake-[0-9.-]*win32-x86.zip" cmdlpage.html | sed -r 's/.*(http.*zip)">.*/\1/' | sed -r 's_.*/(cmake.*).zip_\1_')

echo "Installing CMake version: " $cmake_ver
wget $cmake_url -O cmake.zip
7z x cmake.zip
rsync -a $cmake_ver/ /usr/
cd ~
rm -r -d cmake

#Mingw32 fixes
#cd /mingw32/bin/
#mv gcc.exe gcc64.exe
#mv g++.exe g++64.exe
#mv ld.exe ld64.exe
#Writes Fake GCC, redirect executables with -m32 flag
#cat > "gcc" << 'EOF'
#!/usr/bin/bash
#x86_64-w64-mingw32-gcc -m32 "$@"
#EOF

#cat > "g++" << 'EOF'
#!/usr/bin/bash
#x86_64-w64-mingw32-g++ -m32 "$@"
#EOF

#cat > "ld" << 'EOF'
#!/usr/bin/bash
#ld64 --format=pe-i386 "$@"
#EOF

#create extra directories
if [ ! -d /mingw64/lib/pkgconfig ]; then
mkdir /mingw64/lib/pkgconfig
fi

if [ ! -d /mingw32/lib/pkgconfig ]; then
mkdir /mingw32/lib/pkgconfig
fi

if [ ! -d /mingw64/share/pkgconfig ]; then
mkdir /mingw64/share/pkgconfig
fi

if [ ! -d /mingw32/share/pkgconfig ]; then
mkdir /mingw32/share/pkgconfig
fi

if [ ! -d /mingw64/share/aclocal ]; then
mkdir /mingw64/share/aclocal
fi

if [ ! -d /mingw32/share/aclocal ]; then
mkdir /mingw32/share/aclocal
fi



#Edit profile
cd /etc/
echo "Backing up /etc/profile"
cp ./profile ./profile.original
echo "Modifying profile"
sed '
/\s*\(MINGW32\))/a \
    ACLOCAL_PATH="/mingw32/share/aclocal:/usr/share/aclocal" \
    CC="gcc" \
    CXX="g++" \
    LD="ld" \
    AR="ar" \
    CFLAGS="-m32" \
    CXXFLAGS="-m32" \
    LDFLAGS="-m32" \
' < ./profile > ./profile_1

sed '
/\s*\(MINGW64\))/a \
    ACLOCAL_PATH="/mingw64/share/aclocal:/usr/share/aclocal" \
    CC="gcc" \
    CXX="g++" \
    LD="ld" \
    AR="ar" \
' < ./profile_1 > ./profile_2

mv ./profile ./profile_backup
mv ./profile_2 ./profile



