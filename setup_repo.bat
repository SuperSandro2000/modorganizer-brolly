@echo off
:: Batch does not handle cross Drive operation very well
if not %cd:~0,1%==C echo Please put the script onto Drive C: && pause && exit
:: Working directory. Do not change or stuff will probably break
set wdir=C:\modorganizer-brolly

::set git executable file name
set git=git-2.16.1.4-64-bit.exe

:: UAC Prompt script Source: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
if /I %processor_architecture%==amd64 (
	>nul 2>&1 "%systemroot%\system32\cacls.exe" "%systemroot%\system32\config\system"
) else (
	echo ModOrganizer2 can only be build on 64-bit machines!
	pause && exit
)

if not %errorlevel%==0 goto UACPrompt
if %errorlevel%==0 goto gotAdmin

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c cd %cd% && setup_repo.bat", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
if not exist %wdir% mkdir %wdir%
cd %wdir%
if not exist "C:\Program Files\Git\bin\git.exe" call :install_git
if not %cd%==%wdir% cd %wdir%
:: git command won't work until a cmd restart. workaround for that
set gitdir="C:\Program Files\Git\bin\git.exe"
echo %gitdir%
%gitdir% init C:\modorganizer-brolly
%gitdir% remote add origin https://github.com/SuperSandro2000/modorganizer-brolly.git
%gitdir% pull origin master
%gitdir% submodule init
%gitdir% submodule update
echo Now all other software will be installed
ping 127.0.0.1 -n 6 > nul
call %wdir%\scripts\install_software.bat
echo Repo and Software is done setting up.
echo It can be build by run build_MO2.bat
pause && exit /b

:install_git
if not exist %wdir%\software mkdir %wdir%\software
cd %wdir%\software
echo Downloading Git...
if not exist "%git%" powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.16.1.windows.4/%git%', '%git%')"
if not exist "%wdir%/scripts" mkdir "%wdir%/scripts"
if not exist %wdir%\scripts/git.inf (
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
echo Installing Git...
%git% /LOADINF=%wdir%/scripts/git.inf /SILENT
::restart script to update PATH to contain Git
start %~f0
exit 