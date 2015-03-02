# lsw-build2
MSYS2 Build scripts for building [__L-Smash (32bit)__](https://github.com/l-smash/l-smash) and [__L-Smash Works__](https://github.com/VFR-maniac/L-SMASH-Works/tree/master/AviUtl). 
Not building AviSynth Plugin however.


## Details
This is a set of shell scripts that semi-automate the building of L-Smash and L-Smash Works with Opus audio and Motion JPEG support.
All binaries are **static** if you are running the scripts according to the guide below.
Helper scripts for setting up a newly-installed MSYS2 are also available.
This set of scripts should be faster than the [MSYS version](https://github.com/MaverickTse/lw-build) on a multi-core processor machine.

## How to Download
Use the **Download Zip** button on the right of GitHub page.

## Usage Guide
  1. Install [MSYS2](http://sourceforge.net/projects/msys2/)
  2. First-time startup using **msys2_shell.bat**
  3. Close MSYS2
  4. Copy the script files to _MSYS2ROOT_/home/_UserName_/
  5. Run **msys2_shell.bat**
  6. `./coreupdate.sh` **Restart MSYS2 when finished**
  7. `./inst_base.sh` Exit MSYS2 when finished
  8. Run **mingw32_shell.bat**
  9. `./buildmypkg.sh`
  10. Retrieve your package at _MSYS2ROOT_/ReadyToUse32

On **subsequent rebuild**, just run `./buildmypkg.sh`.
**DO NOT RUN** `pacman -Syu` without first running `./coreupdate.sh` and **restarting MSYS2!**
  