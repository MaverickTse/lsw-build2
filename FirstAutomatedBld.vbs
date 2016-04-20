Dim WshShell
Dim WshFS
Dim WshProcEnv
Dim system_architecture
Dim process_architecture
Dim script_folder
Dim url
Dim cmd1
Dim home_path
Dim strInput
Dim platform
Dim is_downloaded_7za

'Let user to choose the build target(s), 32bit, 64bit or both
strInput= InputBox("Which target to build?" & vbCrlf & "[0]:32-bit" & vbCrlf &"[1]:64-bit" & vbCrlf & "[2]: Both" & vbCrlf & "[3]: Quit","Select platform (All Win-Static)", "0")
  If(Not IsEmpty(strInput)) And (Not IsNull(strInput)) Then
  platform= CInt(strInput)
  If (platform < 0) Then platform=0 End if
  If (platform > 2) Then WScript.Quit 0 End if
  Else
  platform=0
  End If

time_i= Now() 'benchmark timer

Set WshShell =  CreateObject("WScript.Shell")
Set WshProcEnv = WshShell.Environment("Process")
Set WshFS = CreateObject("Scripting.FileSystemObject")

'Check Disk Space
Set drive = WshFS.GetDrive(WshFS.GetDriveName(WScript.ScriptFullName))
'WScript.Echo "FreeSpace: " & FormatNumber(drive.FreeSpace/1048576, 0) & "MB"
driveMB = drive.FreeSpace/1048576
singleBldSzie = 2048 '2GB
doubleBldSize = 3072 '3GB
If (platform < 2) Then
  if (driveMB < singleBldSzie) Then
    WScript.Echo "Insufficient Disk Space!" & vbCrlf & "Requires at least 2GB!"
	Set drive = nothing
	Set WshFS = nothing
	Set WshProcEnv = nothing
	Set WshShell = nothing
	WScript.Quit 1
  end if	
Else
  if (driveMB < doubleBldSize) Then
    WScript.Echo "Insufficient Disk Space!" & vbCrlf & "Requires at least 3GB!"
	Set drive = nothing
	Set WshFS = nothing
	Set WshProcEnv = nothing
	Set WshShell = nothing
    WScript.Quit 1
  end if	
End if

Set drive = nothing  
	

'Check OS bitness
process_architecture= WshProcEnv("PROCESSOR_ARCHITECTURE") 

If process_architecture = "x86" Then    
    system_architecture= WshProcEnv("PROCESSOR_ARCHITEW6432")

    If system_architecture = ""  Then    
        system_architecture = "i686"
    End if    
Else    
    system_architecture = "x86_64"
End If

'Get script folder and set Current Dir
script_folder = WshFS.GetParentFolderName(WScript.ScriptFullName) 'No trailing slash
WshShell.CurrentDirectory = script_folder

'Fetch SourForge DL page
sf_base = "http://sourceforge.net/projects/msys2/files/Base/"
url = sf_base & system_architecture & "/"
cmd1 = """" & WshShell.CurrentDirectory & "\wget.vbs" & """" &" "& url & "  dlpage.html"
Call WshShell.Run(cmd1, 1, True)

'DL wget
If (Not WshFS.FileExists("wget.exe")) Then
wget_fetch="https://eternallybored.org/misc/wget/current/wget.exe wget.exe"
cmd1 = """" & WshShell.CurrentDirectory & "\wget.vbs" & """" &" "& wget_fetch
Call WshShell.Run(cmd1, 1, True)
End if

'Extract Link
Set myregex = New RegExp
myregex.IgnoreCase = True
myregex.Global = True
myregex.Pattern = "href=""(.*tar.xz/download)"
'WScript.Echo(myregex.Pattern)
html= WshFS.OpenTextFile("dlpage.html").ReadAll
Set rMatches = myregex.Execute(html)
url = rMatches.Item(0).Submatches(0)
'Download MSYS2
If (Not WshFS.FileExists("msys2.tar.xz")) Then
cmd1 = """" & WshShell.CurrentDirectory & "\wget.exe" & """" &" " & "" & url & "" & " -O msys2.tar.xz" 
'WScript.Echo(cmd1)
Call WshShell.Run(cmd1, 1, True)
End if

' Check whether 7za has been downloaded
is_downloaded_7za = WshFS.FileExists("7za.exe")
'WScript.Echo(is_downloaded_7za)
If (Not is_downloaded_7za) and (WshFS.FileExists("7za920.zip")) Then
Dim objFile
Set objFile = WshFS.GetFile("7za920.zip")
If objFile.Size > 1 Then is_downloaded_7za = True
End If
'WScript.Echo(is_downloaded_7za)

'DL 7-zip CLI
If (Not is_downloaded_7za) Then
url = "http://downloads.sourceforge.net/sevenzip/7za920.zip"
cmd1 = """" & WshShell.CurrentDirectory & "\wget.exe" & """" &" " & "" & url & "" & " -O 7za920.zip"
'WScript.Echo(cmd1)
Call WshShell.Run(cmd1, 1, True)
End if

'Unzip
If (Not WshFS.FileExists("7za.exe")) Then
Set appShell = CreateObject("Shell.Application")
appShell.NameSpace(WshFS.GetAbsolutePathName(WshShell.CurrentDirectory)).CopyHere appShell.NameSpace(WshFS.GetAbsolutePathName("7za920.zip")).Items
Set appShell = Nothing
End if

'decompress tar.xz
cmd1 = "7za.exe x msys2.tar.xz -so | 7za.exe x -si -ttar -y"
Call WshShell.Run("%comspec% /c " & cmd1, 1, True)

'Set Env Vars in prep for MSYS
Set WshSysEnv= WshShell.Environment("PROCESS")
WshSysEnv("MSYSTEM") = "MSYS"
WshSysEnv("WD") = WshShell.CurrentDirectory & "\msys64\usr\bin\"
mintty_path= WshShell.CurrentDirectory & "\msys64\usr\bin\mintty.exe"
WshSysEnv("MSYSCON") = "mintty.exe"
WshSysEnv("HOME") = WshShell.CurrentDirectory & "\msys64\home\" & WshSysEnv("USERNAME") & "\"

Rem ************** Ready to Launch Mintty ***************************************
cmd1 = "" & mintty_path & "" & " --hold error -i /msys2.ico /usr/bin/bash --login"
WScript.Echo("Please close the MSYS2 Window when it becomes idle (Press OK to Proceed...)")
Call WshShell.Run(cmd1, 1, True) 'First-time launch
'Wait for MSYS to close
Set oWMISvc = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
boolRunning = True
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop
'Set User MSYS home path
home_path = script_folder & "\msys64\home\" & WshSysEnv("USERNAME")
'Copy shell scripts to home
cmd1 = "copy /Y /B " & "" & script_folder & "\*.sh" & "" & " " & "" & home_path & "\" & ""
'WScript.Echo(cmd1)
Call WshShell.Run("%comspec% /c " & cmd1, 1, True)
'core update
cmd1 = "" & mintty_path & "" & " -i /msys2.ico /usr/bin/bash --login " & "" & home_path & "\coreupdate.sh" & ""
Call WshShell.Run(cmd1, 1, True) 'Do update
boolRunning = True 'wait
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop
'install toolchain
cmd1 = "" & mintty_path & "" & " -i /msys2.ico /usr/bin/bash --login " & "" & home_path & "\inst_base.sh" & "" 
Call WshShell.Run(cmd1, 1, True) 'Do update
boolRunning = True 'wait
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop

'Starts building
REM *********** Win32 *****************
If (platform = 0) Or (platform = 2) Then

cmd1 = "" & mintty_path & "" & " --hold error -i /msys2.ico /usr/bin/bash --login " & "" & home_path & "\buildmypkg.sh" & ""
WshSysEnv("MSYSTEM") = "MINGW32" 'Use Mingw32 toolchain
Call WshShell.Run(cmd1, 1, True) 'RUN!
boolRunning = True 'hold
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop
hasVS2013_64 = WshFS.FileExists("C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/Tools/vsvars32.bat")
hasVS2013_32 = WshFS.FileExists("C:/Program Files/Microsoft Visual Studio 12.0/Common7/Tools/vsvars32.bat")
hasVS2012_64 = WshFS.FileExists("C:/Program Files (x86)/Microsoft Visual Studio 11.0/Common7/Tools/vsvars32.bat")
hasVS2012_32 = WshFS.FileExists("C:/Program Files/Microsoft Visual Studio 11.0/Common7/Tools/vsvars32.bat")
If (hasVS2013_64 Or hasVS2013_32 Or hasVS2012_64 Or hasVS2012_32) Then
cmd1 = "" & mintty_path & "" & " -i /msys2.ico /usr/bin/bash --login " & "" & home_path & "\bld_lsw_avs.sh" & ""
WshSysEnv("MSYSTEM") = "MINGW32" 'Use Mingw32 toolchain
Call WshShell.Run(cmd1, 1, True) 'Try to build LSW for AviSynth
boolRunning = True 'hold
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop
End if

End if

REM *********** Win64 *****************
If (platform = 1) Or (platform = 2) Then

cmd1 = "" & mintty_path & "" & " --hold error -i /msys2.ico /usr/bin/bash --login " & "" & home_path & "\buildmypkg_64.sh" & ""
WshSysEnv("MSYSTEM") = "MINGW64" 'Use Mingw32 toolchain
Call WshShell.Run(cmd1, 1, True) 'RUN!
boolRunning = True 'hold
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop
'============ AviSynth in 64 bit mode somehow needs libeinpthread-1.dll ======================
hasVS2013_64 = WshFS.FileExists("C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/Tools/vsvars32.bat")
hasVS2013_32 = WshFS.FileExists("C:/Program Files/Microsoft Visual Studio 12.0/Common7/Tools/vsvars32.bat")
hasVS2012_64 = WshFS.FileExists("C:/Program Files (x86)/Microsoft Visual Studio 11.0/Common7/Tools/vsvars32.bat")
hasVS2012_32 = WshFS.FileExists("C:/Program Files/Microsoft Visual Studio 11.0/Common7/Tools/vsvars32.bat")
If (hasVS2013_64 Or hasVS2013_32 Or hasVS2012_64 Or hasVS2012_32) Then
cmd1 = "" & mintty_path & "" & " -i /msys2.ico /usr/bin/bash --login " & "" & home_path & "\bld_lsw_avs_64.sh" & ""
WshSysEnv("MSYSTEM") = "MINGW64" 'Use Mingw64 toolchain
Call WshShell.Run(cmd1, 1, True) 'Try to build LSW for AviSynth
boolRunning = True 'hold
Do While boolRunning
  Set colProc = oWMISvc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & "mintty.exe" & "'")
  boolRunning = False
  For Each oProc In colProc
    boolRunning = True
  Next
  Set colProc = Nothing
  WScript.Sleep 500
Loop
End if

End if
Rem ***************** Clean up *************************
Set oWMISvc = Nothing
Set WshSysEnv = Nothing
Set appShell = Nothing
Set WshFS = Nothing
Set WshProcEnv = Nothing
Set WshShell = Nothing
Rem ***************** Finish **************************
time_f= Now() 'End benchmark
MsgBox "First-time build Finished in " & DateDiff("n", time_i, time_f) & " minutes."
'Exit Script
WScript.Quit
