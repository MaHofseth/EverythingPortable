:: this space fixes a problem somehow dont remove
@echo off
Color 0A
cls
title Portable Citra Launcher - Experimental Edition
set nag=EXPIREMENTS :D
set new_version=OFFLINE
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

call :Folder-Check
call :Check-Scripts
call :Version
call :Credits

if not exist .\bin\citra\citra-qt.exe set nag=CITRA IS NOT INSTALLED CHOOSE "E"

:Menu
cls
title Portable Citra Launcher - Experimental Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall citra [will remove citra entirely]
echo 2. launch citra [launches citra]
echo 3. reset citra [will remove everything citra except the binary]
echo 4. uninstall citra [Maybe Buy A 3DS :^^)]
echo 5. update script [check for updates]
echo 6. about [shoulda named this credits]
echo 7. exit [EXIT]
echo.
echo a. download dll's [dll errors anyone?]
echo.
echo b. download other projects [check out my other stuff]
echo.
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo.
echo e. check for new citra version [automatically check for a new version]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with exit /b 2 (if they are called by the main menu)
call :%choice%
if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-7 or a/b/c/e"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:Reinstall-Citra
cls
rmdir /s /q .\bin\citra\
call :Citra-Check
exit /b 2

:2
:Launch-Citra
title DO NOT CLOSE
set "UserProfile=%CD%\data"
set "path=%PATH%;%CD%\dll\64\;"
cls
echo CITRA IS RUNNING
start .\bin\citra\citra-qt.exe 
exit

:3
:Reset-Citra
call :NULL
exit /b 2

:4
:Uninstall-Citra
cls
rmdir /s /q .\bin\citra\
exit

:5
:Update-Check
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Citra Launcher - Experimental Edition - Checking For Update
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_36%
if "%new_version%"=="OFFLINE" call :Error-Offline & exit /b 2
if %current_version% EQU %new_version% call :Latest-Build & exit /b 2
if %current_version% LSS %new_version% call :New-Update & exit /b 2
if %current_version% GTR %new_version% call :Preview-Build & exit /b 2
call :Error-Offline & exit /b 2

:6
:About
cls
del .\doc\citra_license.txt
start launch_citra.bat
exit

:7
exit

:a
:DLL-Downloader-Check
cls & title Portable Citra Launcher - Experimental Edition - Download Dll Downloader
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:Portable-Everything
cls & title Portable Citra Launcher - Experimental Edition - Download Suite
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:Quicklauncher-Check
cls
title Portable Citra Launcher - Experimental Edition - Quicklauncher Writer
echo @echo off > quicklaunch_citra.bat
echo Color 0A >> quicklaunch_citra.bat
echo cls >> quicklaunch_citra.bat
echo set "UserProfile=%%CD%%\data" >> quicklaunch_citra.bat
echo set path="%%PATH%%;%%CD%%\dll\64\;" >> quicklaunch_citra.bat
echo cls >> quicklaunch_citra.bat
echo start .\bin\citra\citra-qt.exe >> quicklaunch_citra.bat
echo exit >> quicklaunch_citra.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_citra.bat
echo ENTER TO CONTINUE & pause>nul:
exit /b 2

:e
:Upgrade-Citra
title Portable Citra Launcher - Experimental Edition - Update Citra
if not exist .\extra\citra-setup-windows.exe (
    if not exist .\bin\wget.exe call :Download-Wget
    .\bin\wget.exe -q --show-progress https://github.com/citra-emu/citra-web/releases/download/1.0/citra-setup-windows.exe
    move citra-setup-windows.exe .\extra\citra-setup-windows.exe
    goto Upgrade-Citra
)
echo continue with installation,
echo when prompted for location enter,
echo "%CD%\bin\citra"
pause
.\extra\citra-setup-windows.exe
cls
for /d %%i in (".\bin\citra\*") do if /i not "%%i"==".\bin\citra\nightly-mingw" rmdir /s /q "%%i"
for /R %%i in (.\bin\citra\*) do del "%%i"
xcopy .\bin\citra\nightly-mingw\* .\bin\citra\ /e /i /y
rmdir /s /q .\bin\citra\nightly-mingw\
exit /b 2

########################################################################

:: program specific stuff that can easily be changed below
:: stuff that is almost identical betwwen stuff

########################################################################

:Folder-Check
cls
if not exist .\bin\ mkdir .\bin\
:: dll folder check removed because dll downloader creates it
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\note\ mkdir .\note\
(goto) 2>nul

########################################################################

:Version
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

########################################################################

:Credits
cls
if exist .\doc\citra_license.txt (goto) 2>nul
echo ================================================== > .\doc\citra_license.txt
echo =              Script by MarioMasta64            = >> .\doc\citra_license.txt
echo =           Script Version: v%current_version%- release         = >> .\doc\citra_license.txt
echo ================================================== >> .\doc\citra_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\citra_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\citra_license.txt
echo =      as you include a copy of the License      = >> .\doc\citra_license.txt
echo ================================================== >> .\doc\citra_license.txt
echo =    You may also modify this script without     = >> .\doc\citra_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\citra_license.txt
echo ================================================== >> .\doc\citra_license.txt
cls
title Portable Citra Launcher - Experimental Edition - About
for /f "DELIMS=" %%i in (.\doc\citra_license.txt) do (echo %%i)
pause
call :Ping-Install
(goto) 2>nul

########################################################################

:: if a script can be used between files then it can be put here and re-written only if it doesnt exist
:: stuff here will not be changed between programs

########################################################################

:Set-Arch
set arch=32
if exist "%PROGRAMFILES(X86)%" set "arch=64"
(goto) 2>nul

########################################################################

:Check-Scripts
if not exist .\bin\downloadwget.vbs call :Create-Wget-Downloader
if not exist .\bin\hide.vbs call :Create-Hide
if not exist .\bin\extractzip.vbs call :Create-Zip-Extractor
if not exist .\bin\replacetext.vbs call :Create-Text-Replacer
(goto) 2>nul

########################################################################

:Create-Wget-Downloader
echo ' Set your settings > .\bin\downloadwget.vbs
echo    strFileURL = "https://eternallybored.org/misc/wget/current/wget.exe" >> .\bin\downloadwget.vbs
echo    strHDLocation = "wget.exe" >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo ' Fetch the file >> .\bin\downloadwget.vbs
echo     Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo     objXMLHTTP.open "GET", strFileURL, false >> .\bin\downloadwget.vbs
echo     objXMLHTTP.send() >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo If objXMLHTTP.Status = 200 Then >> .\bin\downloadwget.vbs
echo Set objADOStream = CreateObject("ADODB.Stream") >> .\bin\downloadwget.vbs
echo objADOStream.Open >> .\bin\downloadwget.vbs
echo objADOStream.Type = 1 'adTypeBinary >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.Write objXMLHTTP.ResponseBody >> .\bin\downloadwget.vbs
echo objADOStream.Position = 0    'Set the stream position to the start >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objFSO = Createobject("Scripting.FileSystemObject") >> .\bin\downloadwget.vbs
echo If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation >> .\bin\downloadwget.vbs
echo Set objFSO = Nothing >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.SaveToFile strHDLocation >> .\bin\downloadwget.vbs
echo objADOStream.Close >> .\bin\downloadwget.vbs
echo Set objADOStream = Nothing >> .\bin\downloadwget.vbs
echo End if >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objXMLHTTP = Nothing >> .\bin\downloadwget.vbs
(goto) 2>nul

########################################################################

:Create-Hide
echo CreateObject("Wscript.Shell").Run """" ^& WScript.Arguments(0) ^& """", 0, False > .\bin\hide.vbs
(goto) 2>nul

########################################################################

:Create-Zip-Extractor
echo 'The location of the zip file. > .\bin\extractzip.vbs
echo ZipFile = Wscript.Arguments(0) >> .\bin\extractzip.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractzip.vbs
echo ExtractTo = Wscript.Arguments(1) >> .\bin\extractzip.vbs
echo. >> .\bin\extractzip.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractzip.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractzip.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractzip.vbs
echo fso.CreateFolder(ExtractTo) >> .\bin\extractzip.vbs
echo End If >> .\bin\extractzip.vbs
echo. >> .\bin\extractzip.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractzip.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractzip.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractzip.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractzip.vbs
echo Set fso = Nothing >> .\bin\extractzip.vbs
echo Set objShell = Nothing >> .\bin\extractzip.vbs
(goto) 2>nul

########################################################################

:Create-Text-Replacer
echo Const ForReading = 1 > .\bin\replacetext.vbs
echo Const ForWriting = 2 >> .\bin\replacetext.vbs
echo. >> .\bin\replacetext.vbs
echo strFileName = Wscript.Arguments(0) >> .\bin\replacetext.vbs
echo strOldText = Wscript.Arguments(1) >> .\bin\replacetext.vbs
echo strNewText = Wscript.Arguments(2) >> .\bin\replacetext.vbs
echo. >> .\bin\replacetext.vbs
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> .\bin\replacetext.vbs
echo Set objFile = objFSO.OpenTextFile(strFileName, ForReading) >> .\bin\replacetext.vbs
echo strText = objFile.ReadAll >> .\bin\replacetext.vbs
echo objFile.Close >> .\bin\replacetext.vbs
echo. >> .\bin\replacetext.vbs
echo strNewText = Replace(strText, strOldText, strNewText) >> .\bin\replacetext.vbs
echo Set objFile = objFSO.OpenTextFile(strFileName, ForWriting) >> .\bin\replacetext.vbs
echo objFile.Write strNewText  'WriteLine adds extra CR/LF >> .\bin\replacetext.vbs
echo objFile.Close >> .\bin\replacetext.vbs
(goto) 2>nul

########################################################################

:Ping-Install
if not exist .\bin\wget.exe call :Download-Wget
setlocal enabledelayedexpansion
for /F "skip=1 tokens=5" %%a in ('vol %~D0') do echo %%a>serial.txt
set /a count=1 
for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "serial.txt" sha1') do (
  if !count! equ 1 set "sha1=%%a"
  set/a count+=1
)
set "sha1=%sha1: =%
echo %sha1%
set program=%~n0
echo %program:~7%
echo http://old-school-gamer.tk/install/new_install.php?program=%program:~7%^&serial=%sha1%
.\bin\wget -q --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36" http://old-school-gamer.tk/install/new_install.php?program=%program:~7%^&serial=%sha1%
endlocal
del new_install.php*
del serial.txt
(goto) 2>nul

########################################################################

:MoTD
if not exist .\bin\wget.exe call :Download-Wget
title checking for message of the day
set program=%~n0>nul:
.\bin\wget.exe -q --show-progress https://github.com/MarioMasta64/EverythingPortable/raw/master/note/motd.txt>nul:
if exist motd.txt del .\note\motd.txt>nul:
if exist motd.txt (
  del /q .\note\motd.txt>nul:
  copy motd.txt .\note\motd.txt
)
if exist .\note\motd.txt for /f "DELIMS=" %%i in ('type .\note\motd.txt') do (set nag=%%i)
del /q motd.txt*>nul:
(goto) 2>nul

########################################################################

End Of Scripts

########################################################################

:Extract-Zip
cls
set dir=%1
set file=%2
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cscript .\bin\extractzip.vbs "%folder%\%file%" "%folder%\%dir%"
(goto) 2>nul

########################################################################

:Download-Wget
cls
title Portable Citra Launcher - Experimental Edition - Download Wget
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:: scripts that are program specific are below

#######################################################################

:: scripts that are made to cleanup or move directories and files between releases are below

########################################################################

:: scripts that are used for updating things are below

########################################################################

:Update-Wget
cls
title Portable Citra Launcher - Experimental Edition - Update Wget
.\bin\wget.exe -q --show-progress https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Latest-Build
cls
title Portable Citra Launcher - Experimental Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_citra.bat
exit

:New-Update
cls
title Portable Citra Launcher - Experimental Edition - Old Build D:
echo %NAG%
set nag="Selection Time!"
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%choice%"=="yes" call :Update-Now & (goto) 2>nul
if "%choice%"=="no" (goto) 2>nul
set nag="please enter YES or NO"
goto New-Update

:Update-Now
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & title Portable Citra Launcher - Experimental Edition - Updating Launcher
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_citra.bat
cls & if exist launch_citra.bat.1 goto Replacer-Create
cls & call :Error-Offline
(goto) 2>nul

:Replacer-Create
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_citra.bat >> replacer.bat
echo rename launch_citra.bat.1 launch_citra.bat >> replacer.bat
echo start launch_citra.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
wscript "%CD%\bin\hide.vbs" "replacer.bat"
exit

:Preview-Build
cls
title Portable Citra Launcher - Experimental Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
echo ENTER TO CONTINUE & pause>nul:
start launch_citra.bat
exit

########################################################################

:Error-Offline
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
(goto) 2>nul

########################################################################

:: General Purpose Scripts Are Below

########################################################################

:Alpha-To-Number
set a=1
set b=2
set c=3
set d=4
set e=5
set f=6
set g=7
set h=8
set i=9
set j=10
set k=11
set l=12
set m=13
set n=14
set o=15
set p=16
set q=17
set r=18
set s=19
set t=20
set u=21
set v=22
set w=23
set x=24
set y=25
set z=26
(goto) 2>nul

########################################################################

:View-Code
start notepad.exe "%~f0"
(goto) 2>nul

########################################################################

:Make-Copy
:Save-Copy
del "%~f0.bak"
copy "%~f0" "%~f0.bak"
(goto) 2>nul

########################################################################

:cmd
cls
title Portable Citra Launcher - Experimental Edition - Command Prompt - By MarioMasta64
ver
echo (C) Copyright Microsoft Corporation. All rights reserved
echo.
echo nice job finding me. have fun with my little cmd prompt.
echo upon error (more likely than not) i will return to the menu.
echo type "(goto) 2^>nul" or make me error to return.
echo.
:cmd-loop
set /p "cmd=%cd%>"
if "%cmd%"=="reset-cmd" call :cmd
%cmd%
echo.
goto cmd-loop

########################################################################

:Relaunch
echo @echo off > relaunch.bat
echo cls >> relauncher.bat
echo Color 0A >> relaunch.bat
echo start %~f0 >> relaunch.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> relaunch.bat
wscript "%CD%\bin\hide.vbs" "relaunch.bat"
exit

########################################################################

:: notes i guess

########################################################################

replace launch_citra.bat with %~f0
because i use the call command. you can edit the file add a label and goto the label by typing it in the menu without even having to close the program cause youre worried about it glitching (put your code on the bottom)
add raw before raw/master in everything
maybe add option to open mod folder?
add new launchers to update check in everything portable
the better link: https://raw.githubusercontent.com/MarioMasta64/ModDownloaderPortable/master/mod_list.txt
apparently raw is bad before master but only sometimes?
raw is perfect for text links tho

########################################################################
