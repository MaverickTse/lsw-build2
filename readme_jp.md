# lsw-build2
MSYS2をつかって、[__L-Smash (32bit)__](https://github.com/l-smash/l-smash) と [__L-Smash Works__](https://github.com/VFR-maniac/L-SMASH-Works/tree/master/AviUtl)を簡単にビルドするスクリプト群です。 


## 詳細
これは"Opus audio"と"Motion JPEG"をサポートするL-Smash と L-Smash Worksを半自動的にビルドするシェルスクリプトのセットです。
下記に示す手順を守れば生成物（バイナリ）は静的(**static**)になります。
ビルドのために必要となるMSYS2の環境を構築するスクリプトも付属しています（OSのPATHは変更しません）。
マルチコアCPU（近年のほとんどのCPU）では[MSYSを利用する物](https://github.com/MaverickTse/lw-build)より高速にビルドできます。

## Download方法
GitHubの画面右下にある **Download Zip** ボタンを使ってください。
もしすでにgitを利用できる環境をお持ちでしたら、
>`git clone https://github.com/MaverickTse/lsw-build2.git`

とすればダウンロード出来ます（zipの解凍の手間がなくなる）。


## 初回のビルド方法（自動化版）
  1. 「Download方法」にしたがってダウンロードし、zipファイルを解凍、ビルドツールを置きたい場所に配置
  2. **FirstAutomatedBld.vbs**　をダブルクリックする
  3. [0]:32-bit [1]:64-bit [2]: 両方 を入力してビルドターゲットを選択します。ここで終了するには 3 を入力します。
  4. 途中ダイアログが出るので「OK」をクリックする。しばらくすると「CAUTION」と大きく書かれた画面にコンソールがなるのでウィンドウを閉じる
  5. ffmpegやL-SMASH/L-SMASH Worlsのビルドが始まります。ビルドにはしばらくかかります。
  6. 終了するとビルドにかかった時間がダイアログに表示されます。「OK」で閉じます。
  7. `_MSYS2ROOT_\ReadyToUse32`にビルド生成物が有ります。
  8. **(追記)**AviSynth pluginは、Visual Studio 2012 または Visual Stusio 2013がインストールされている時のみビルドされます。

>Visual Studio Community 2013 Update 4

>http://www.visualstudio.com/ja-jp/downloads/download-visual-studio-vs#d-community-expando
  

## 初回のビルド方法 (半自動版)
  1. [MSYS2](http://sourceforge.net/projects/msys2/)をインストールする（[msys2-base-x86_64-[date].tar.xz](http://sourceforge.net/projects/msys2/files/Base/x86_64/)を解凍するだけ）。
  2. **msys2_shell.bat** を実行する。
  3. 終わったらMSYS2のコンソールを終了する
  4. スクリプト群を `MSYS2ROOT/home/UserName/` にコピーする。
  5. 再び **msys2_shell.bat** を実行する。
  6. `./coreupdate.sh`と打ち実行、 **終了したら MSYS2のコンソールを再起動する**
  7. `./inst_base.sh` と打ち実行、 終了したら MSYS2のコンソールを閉じる
  8.  32bit向けには**mingw32_shell.bat** を、64bit向けには**mingw64_shell.bat**を実行する。**msys2_shell.batではない！** 
  9.  32bit向けには`./buildmypkg.sh`、64bit向けには`./buildmypkg_64.sh`と打ち実行する。
  10. VS2012 か VS2013がインストールされていて、L-SMASH WorksのAviSynth向けプラグイン(LSMASHSource.dll)をビルドしたい場合は、32bit向けには`./bld_lsw_avs.sh`、64bit向けには`./bld_lsw_avs_64.sh`と打ち実行
  11. `MSYS2ROOT\ReadyToUse32`にビルド生成物が有ります。
  
  
## 注意！
`./coreupdate.sh`を実行し、**MSYS2のコンソールを再起動する**まで、`pacman -Syu` を**実行してはならない**。

## リビルドの方法
  1. 32bit向けには**mingw32_shell.bat** を、64bit向けには**mingw64_shell.bat**を実行する。**msys2_shell.batではない！** 
  2. 32bit向けには`./buildmypkg.sh`、64bit向けには`./buildmypkg_64.sh`と打ち実行する。

