@echo off

:: Working directory. Do not change or stuff will probably break
set wdir=C:\modorganizer-brolly

:: set executable file names. URLs can change with every release and are simply changed in call: download
set git=git-2.16.1.4-64-bit.exe
set 7zip=7z1801-x64.msi
set cmake=cmake-3.10.2-win64-x64.msi
set python=python-2.7.14.amd64.msi
set qt=qt-unified-windows-x86-online.exe
set vs=vs_Community.exe

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
    echo Set UAC = CreateObject^("Shell.Application"^) > "%wdir%\scripts\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c cd %cd% && software.bat", "", "runas", 1 >> "%wdir%\scripts\getadmin.vbs"
    "%temp%\getadmin.vbs"
   rem del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
cd %wdir%

if not exist "software" mkdir software 
cd software
::debug
goto a
if not "%git%" exist call :download https://github.com/git-for-windows/git/releases/download/v2.16.1.windows.4/%git% %git%
%git% /LOADINF=%wdir%/scripts/git.inf /SILENT

if not "%7zip%" exist call :download http://www.7-zip.org/a/%7zip% %7zip%
%7zip% /passive

if not "%cmake%" exist call :download https://cmake.org/files/v3.10/%cmake% %cmake%
%cmake% /passive

if not "%python%" exist call :download https://www.python.org/ftp/python/2.7.14/%python% %python%%
%python% /passive

if not "%qt%" exist call :download https://download.qt.io/official_releases/online_installers/%qt% %qt%
%qt% --script "%wdir%\scripts\qt.qs"

:a
if not "%vs%" exist call :download https://aka.ms/vs/15/release/vs_community.exe %vs%
::%vs% --add Microsoft.VisualStudio.Workload.CoreEditor --passive --norestart
%vs% --add Microsoft.VisualStudio.Workload.CoreEditor --add Microsoft.Net.Component.4.5.TargetingPack --add Microsoft.Net.Component.4.6.TargetingPack --add Microsoft.VisualStudio.Workload.NativeDesktop --passive --norestart --wait

cd ..
echo Done
pause && exit

:download
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')"
exit /b 0