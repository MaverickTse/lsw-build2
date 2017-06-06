cd ~
if [ ! -d cmake ]; then
    mkdir cmake
fi
cd cmake
wget https://cmake.org/download/ -O cmdlpage.html
#domain changed in 2015 October

#cmake_url=$(grep -m 1 "cmake-[0-9.-]*win32-x86.zip" cmdlpage.html | sed -r 's/.*(http.*zip)">.*/\1/')
cmake_url=$(grep 'win32-x86.zip' cmdlpage.html | grep -v 'rc' | head -n1 | sed -r 's/(^.+href=")(.*zip)(".*)/https:\/\/cmake.org\2/')
#cmake_ver=$(grep -m 1 "cmake-[0-9.-]*win32-x86.zip" cmdlpage.html | sed -r 's/.*(http.*zip)">.*/\1/' | sed -r 's_.*/(cmake.*).zip_\1_')
cmake_ver=$(grep 'win32-x86.zip' cmdlpage.html| grep -v 'rc' | head -n1 | sed -r 's/(^.+href=")(.+?cmake-)(.+?)(-win32-x86.zip)(".*)/\3/')
echo "Installing CMake version: " $cmake_ver
if [ ! -f cmake-${cmake_ver}.zip ]; then
    wget $cmake_url -O cmake.zip
fi
if [ ! -d cmake-${cmake_ver}-win32-x86 ]; then
    unzip -q cmake-${cmake_ver}.zip
fi
rsync -a cmake-${cmake_ver}-win32-x86/ /usr/
cd ~
