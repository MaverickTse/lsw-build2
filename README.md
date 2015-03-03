# lsw-build2
MSYS2 Build scripts for building [__L-Smash (32bit)__](https://github.com/l-smash/l-smash) and [__L-Smash Works__](https://github.com/VFR-maniac/L-SMASH-Works/tree/master/AviUtl). 


## Details
This is a set of shell scripts that semi-automate the building of L-Smash and L-Smash Works with Opus audio and Motion JPEG support.
All binaries are **static** if you are running the scripts according to the guide below.
Helper scripts for setting up a newly-installed MSYS2 are also available.
This set of scripts should be faster than the [MSYS version](https://github.com/MaverickTse/lw-build) on a multi-core processor machine.

## How to Download
Use the **Download Zip** button on the right of GitHub page.

## DEAD SIMPLE First-time Build Guide
  1. Download this package and extract to some empty folder
  2. Double-Click on **FirstAutomatedBld.vbs**
  3. When prompted, click OK. Wait a moment, then close the MSYS2 Window
  4. Go to watch an episode of animation...
  5. It should popup a dialog showing the time taken to build
  6. Close the dialog, and get your packages in _MSYS2ROOT_\ReadyToUse32
  7. **P.S.:** _The AviSynth plugin will only be built if you have either VS2012 or VS2013 installed_
  
  
## Usage Guide (Manual)
  1. Install [MSYS2](http://sourceforge.net/projects/msys2/)
  2. First-time startup using **msys2_shell.bat**
  3. Close MSYS2
  4. Copy the script files to _MSYS2ROOT_/home/_UserName_/
  5. Run **msys2_shell.bat**
  6. `./coreupdate.sh` **Restart MSYS2 when finished**
  7. `./inst_base.sh` Exit MSYS2 when finished
  8. Run **mingw32_shell.bat**
  9. `./buildmypkg.sh`
  10. If you have VS2012 or VS2013 and want to build LSW for AviSynth, run `./bld_lsw_avs.sh`
  11. Retrieve your package at _MSYS2ROOT_/ReadyToUse32
  
## Caution
**DO NOT RUN** `pacman -Syu` without first running `./coreupdate.sh` and **restarting MSYS2!**

## How to Rebuild
  1. Run **mingw32_shell.bat**
  2. `./buildmypkg.sh`
  