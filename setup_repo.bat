@echo off

:: Working directory. Do not change or stuff will probably break
set wdir=C:\modorganizer-brolly

::set git executable file name
set git=git-2.16.1.4-64-bit.exe

:: UAC Prompt script Source: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
if /I %processor_architecture%==amd64 (
	>nul 2>&1 "%systemroot%\SysWOW64\cacls.exe" "%systemroot%\SysWOW64\config\system"
) else (
	::>nul 2>&1 "%systemroot%\system32\cacls.exe" "%systemroot%\system32\config\system"
	echo ModOrganizer2 can only be build on 64-bit machines!
	pause && exit
)

if %errorlevel%==5 goto UACPrompt
if %errorlevel%==2 goto gotAdmin
echo unspecific error
echo errorlevel %errorlevel% 
echo pls ask in the modorganizer discord for help.
pause && exit

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c cd %cd% && setup_repo.bat", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
if not exist %wdir% && mkdir %wdir%
cd %wdir%
if not exist "C:\Program Files\Git\bin\git.exe" goto install_git
if not %cd%==%wdir% cd %wdir%
git clone -f https://github.com/SuperSandro2000/modorganizer-brolly.git C:\modorganizer-brolly
git submodule init
git submodule update
echo Now all other software will be installed
ping 127.0.0.1 -n 6 > nul
call scripts\install_software.bat

:install_git
if not exist %wdir%\software && mkdir %wdir%\software
cd %wdir%\software
if not "%git%" powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.16.1.windows.4/%git%', '%git%')"
(
	echo [Setup]
	echo Lang=default
	echo Dir=C:\Program Files\Git
	echo Group=Git
	echo NoIcons=1
	echo SetupType=default
	echo Components=gitlfs,assoc,assoc_sh,autoupdate
	echo Tasks=
	echo EditorOption=Nano
	echo PathOption=Cmd
	echo SSHOption=OpenSSH
	echo CURLOption=OpenSSL
	echo CRLFOption=CRLFAlways
	echo BashTerminalOption=MinTTY
	echo PerformanceTweaksFSCache=Enabled
	echo UseCredentialManager=Enabled
	echo EnableSymlinks=Disabled
) >> %wdir%/scripts/git.inf
%git% /LOADINF=%wdir%/scripts/git.inf /SILENT
exit /b