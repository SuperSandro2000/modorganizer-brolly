@echo off

::abort if C:\Qt folder exists
if exist "C:\Qt" (
	echo C:\Qt folder found. Please uninstall it
	echo or manually install the required packages
)

:: Working directory. Do not change or stuff will probably break
set wdir=C:\modorganizer-brolly

:: set executable file names. URLs can change with every release and are simply changed in call: download
set sevenzip=7z1801-x64.msi
set cmake=cmake-3.10.2-win64-x64.msi
set python=python-2.7.14.amd64.msi
set qt=qt-unified-windows-x86-online.exe
set vs=vs_Community.exe

if not %cd%==%wdir% cd %wdir%
if not exist "software" mkdir software 
cd software

if not exist "%sevenzip%" call :download "http://www.7-zip.org/a/%sevenzip%" %sevenzip%
echo Installing 7zip...
%sevenzip% /passive

if not exist "%cmake%" call :download "https://cmake.org/files/v3.10/%cmake%" %cmake%
echo Installing CMake...
%cmake% /passive ADD_CMAKE_TO_PATH=System ALLUSERS=1

if not exist "%python%" call :download "https://www.python.org/ftp/python/2.7.14/%python%" %python%
echo Installing Python...
%python% /passive INSTALLLEVEL=1 ADDLOCAL=DefaultFeature,SharedCRT,Extensions,TclTk,Documentation,Tools,pip_feature,Testsuite,PrependPath

if not exist "C:\Qt" (
	if not exist "%qt%" call :download "https://download.qt.io/official_releases/online_installers/%qt%" %qt%
	echo Installing Qt...
	:: | rem is a workaround to wait until Qt is done with installing
	%qt% --script "%wdir%\scripts\qt.qs"|rem
)

if not exist "%vs%" call :download "https://aka.ms/vs/15/release/vs_community.exe" %vs%
echo Installing VisualStudio Community...
%vs% --add Microsoft.VisualStudio.Workload.CoreEditor --add Microsoft.Net.Component.4.5.TargetingPack --add Microsoft.Net.Component.4.6.TargetingPack --add Microsoft.VisualStudio.Workload.NativeDesktop --passive --norestart --wait

echo Done Installing software.
set /p clean=Should the download folder be cleaned up? [Y/N]
if /I %clean%==y del * /Q
cd ..
exit /b

:download
echo Downloading %~2...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')"
exit /b