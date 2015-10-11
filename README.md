# Currently BROKEN, Under investigation
# lsw-build2(TDM)
MSYS2 Build scripts for building [__L-Smash__](https://github.com/l-smash/l-smash) and [__L-Smash Works__](https://github.com/VFR-maniac/L-SMASH-Works/tree/master/AviUtl). 

**The master branch now use the TDM64-GCC toolchain instead of the one from pacman**


## Details
This is a set of shell scripts that semi-automate the building of L-Smash and L-Smash Works with Opus audio and Motion JPEG support.
All binaries are **static** if you are running the scripts according to the guide below.
Helper scripts for setting up a newly-installed MSYS2 are also available.
This set of scripts should be faster than the [MSYS version](https://github.com/MaverickTse/lw-build) on a multi-core processor machine.

## How to Download
Use the **Download Zip** button on the right of GitHub page.

## DEAD SIMPLE First-time Build Guide
**Note on 20 May,2015: IF a screen full of ~tilds appears asking for reason to merge, type:** `:exit` then ENTER.
  1. Download this package and extract to some empty folder
  2. Double-Click on **FirstAutomatedBld.vbs**
  3. Select a build target by typing [0]:32-bit, [1]:64-bit or [2]: Both then ENTER. Type 3 to Abort.
  4. When prompted, click OK. Wait a moment, then close the MSYS2 Window
  5. Go to watch 2 episodes of animation...(On Core-i7, building both 32 and 64 bit binaries takes around 30min)
  6. It should popup a dialog showing the time taken to build
  7. Close the dialog, and get your packages in _MSYS2ROOT_\ReadyToUse32 and _MSYS2ROOT_\ReadyToUse64
  8. **P.S.:** _The AviSynth plugin will only be built if you have either VS2012 or VS2013 installed_
  9. **P.S.:** _32bit and 64bit FFmpeg.exe can be found inside `msys64/mingw32/bin` and `msys64/mingw64/bin`, respectively.
  
  [VS2013 Community Edition Info](https://www.visualstudio.com/en-us/news/vs2013-community-vs.aspx)
  
   
  
  
## Usage Guide (Manual)
  1. Install [MSYS2](http://sourceforge.net/projects/msys2/)
  2. First-time startup using **msys2_shell.bat**
  3. Close MSYS2
  4. Copy the script files to _MSYS2ROOT_/home/_UserName_/
  5. Run **msys2_shell.bat**
  6. `./coreupdate.sh` **Restart MSYS2 when finished**
  7. `./inst_base.sh` Exit MSYS2 when finished
  8. Run **mingw32_shell.bat** for 32bit target, **mingw64_shell.bat** for 64bit target
  9. `./buildmypkg.sh` or `./buildmypkg_64.sh`
  10. If you have VS2012 or VS2013 and want to build LSW for AviSynth, run `./bld_lsw_avs.sh` or `./bld_lsw_avs_64.sh`
  11. Retrieve your package at _MSYS2ROOT_/ReadyToUse32
  
## Caution
**DO NOT RUN** `pacman -Syu` without first running `./coreupdate.sh` and **restarting MSYS2!**

## How to Rebuild
  1. Run **mingw32_shell.bat** for 32bit target, **mingw64_shell.bat** for 64bit target
  2. `./buildmypkg.sh` or `./buildmypkg_64.sh`
  
