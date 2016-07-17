# lsw-build2
MSYS2をつかって、[__L-Smash__](https://github.com/l-smash/l-smash) と [__L-Smash Works__](https://github.com/VFR-maniac/L-SMASH-Works/tree/master/AviUtl)を簡単にビルドするスクリプト群です。 

コンパイラーにはmsys2のpacman(パッケージ管理ツール)で落ちるgccではなく、**TDM64-GCCを使用します**。


## 詳細
これは"Opus audio"と"Motion JPEG"をサポートするL-Smash と L-Smash Works(ついでにffmpeg)を半自動的にビルドするシェルスクリプトのセットです。
下記に示す手順を守れば生成物（バイナリ）は静的(**static**)になります。
ビルドのために必要となるMSYS2の環境を構築するスクリプトも付属しています（OSのPATHは変更しません）。
マルチコアCPU（近年のほとんどのCPU）では[MSYSを利用する物](https://github.com/MaverickTse/lw-build)より高速にビルドできます。

## Download方法
GitHubの画面右下
>https://github.com/MaverickTse/lsw-build2

にある **Download Zip** ボタンを使ってください。
もしすでにgitを利用できる環境をお持ちでしたら、
>`git clone https://github.com/MaverickTse/lsw-build2.git`

とすればダウンロード出来ます（zipの解凍の手間がなくなる）。


## 初回のビルド方法（自動化版）
### 注意
- 通信回線が安定している状態で実行してください。
- ~~AviSynth向けL-SMASH Works plugin のbuildにはVisual Studio 2013/2015が必要です。  
存在しない場合AviSynth向けL-SMASH Works plugin のbuildはskipされます~~
[AviSynth向けL-SMASH Works plugin のbuildにはVisual Studioでコンパイルされたffmpegの.libが必要になりました。](https://github.com/VFR-maniac/L-SMASH-Works/commit/71859e2428c1d8cb7ed44dd2121ed95be9a8a233)**これに伴い、このスクリプト群でのビルドのサポートを見合わせています。詳しくは[Wiki](https://github.com/MaverickTse/lsw-build2/wiki/04-Building-LSW-for-Avisynth)へ**
- Note on 20 May,2015: IF a screen full of ~tilds appears asking for reason to merge, type: ``:exit`` then ENTER.

### 手順
  1. 「Download方法」にしたがってダウンロードし、zipファイルを解凍、ビルドツールを置きたい場所に配置
  2. **FirstAutomatedBld.vbs**　をダブルクリックする
  3. [0]:32-bit [1]:64-bit [2]: 両方 を入力してビルドターゲットを選択します。ここで終了するには 3 を入力します。
  4. 途中ダイアログが出るので「OK」をクリックする。しばらくすると「CAUTION」と大きく書かれた画面にコンソールがなるのでウィンドウを閉じる
  5. ffmpegやL-SMASH/L-SMASH Worlsのビルドが始まります。ビルドにはしばらくかかります(Intel Core i5-4200Mでは45分以上, Intel Core i5-6600では30分)。
  6. 終了するとビルドにかかった時間がダイアログに表示されます。「OK」で閉じます。
  7. `MSYS2ROOT\ReadyToUse32`(32bit向け)または`MSYS2ROOT\ReadyToUse64`(64bit向け)にビルド生成物が有ります。
  8. ~~(追記)AviSynth pluginは、Visual Studio 2013 または Visual Stusio 2015がインストールされている時のみビルドされます。~~
  9. **(追記)** 32bit版と64bit版のFFmpeg.exeはそれぞれ`msys64/mingw32/bin`と`msys64/mingw64/bin`にあります。

### 失敗した時
Script Errorが出る場合はMSYS2と7zipのDLに失敗している可能性が高いので下を試す

  1. もし存在したら``msys2.tar.xz``を削除
  2. [msys2-base-x86_64-[date].tar.xz](http://sourceforge.net/projects/msys2/files/Base/x86_64/)(64bitOS向け)または[msys2-base-i686-[date].tar.xz](http://sourceforge.net/projects/msys2/files/Base/i686/)(32bitOS向け)をDLする
  2. ``msys2.tar.xz``にリネーム
  3. [7za920.zip](http://downloads.sourceforge.net/sevenzip/7za920.zip)を落とす
  4. 2つとも``FirstAutomatedBld.vbs``と同じ所に置く
  5. ``FirstAutomatedBld.vbs``をダブルクリックして実行
  6. これでもダメなら初回のビルド方法 (半自動版)を試す。[Issue](https://github.com/MaverickTse/lsw-build2/issues)に失敗情報を書いてくれると他の人のためになります。

  

## 初回のビルド方法 (半自動版)
### 注意！
- ~~`./coreupdate.sh`を実行し、**MSYS2のコンソールを再起動する**まで、`pacman -Syu` を**決して実行しないでください**。~~
- この方法はめんdです。なので自動化版の手順に失敗した時のみ試してみてください。

### 手順
  1. [msys2-base-x86_64-[date].tar.xz](http://sourceforge.net/projects/msys2/files/Base/x86_64/)(64bitOS向け)または[msys2-base-i686-[date].tar.xz](http://sourceforge.net/projects/msys2/files/Base/i686/)(32bitOS向け)をDLし、解凍する。
  2. **msys2_shell.bat** を実行する。
  3. 終わったらMSYS2のコンソールを終了する
  4. スクリプト群を `MSYS2ROOT/home/UserName/` にコピーする。
  5. 再び **msys2_shell.bat** を実行する。
  6. `./coreupdate.sh`と打ち実行、 **終了したら MSYS2のコンソールを再起動する**
  7. `./inst_base.sh` と打ち実行、 終了したら MSYS2のコンソールを閉じる
  8. ``msys2_shell.cmd``があるフォルダで``Shift``+右クリックで「コマンドウィンドウをここで開く」をクリックする
  9. 32bit向けには**call msys2\_shell.cmd -mingw32** を、64bit向けには**call msys2\_shell.cmd -mingw64**を実行する。
  10.  32bit向けには`./buildmypkg.sh`、64bit向けには`./buildmypkg_64.sh`と打ち実行する。
  11. ~~VS2013/2015がインストールされていて、L-SMASH WorksのAviSynth向けプラグイン(LSMASHSource.dll)をビルドしたい場合は、32bit向けには`./bld_lsw_avs.sh`、64bit向けには`./bld_lsw_avs_64.sh`と打ち実行~~
  12. `MSYS2ROOT\ReadyToUse32`(32bit向け)または`MSYS2ROOT\ReadyToUse64`(64bit向け)にビルド生成物が有ります。
  
  
## リビルドの方法
  1. ``msys2_shell.cmd``があるフォルダで``Shift``+右クリックで「コマンドウィンドウをここで開く」をクリックする
  2. 32bit向けには**call msys2\_shell.cmd -mingw32** を、64bit向けには**call msys2\_shell.cmd -mingw64**を実行する。
  3. 32bit向けには`./buildmypkg.sh`、64bit向けには`./buildmypkg_64.sh`と打ち実行する。

