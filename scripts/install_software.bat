@echo off

:: Working directory. Do not change or stuff will probably break
set wdir=C:\modorganizer-brolly

:: set executable file names. URLs can change with every release and are simply changed in call: download
set 7zip=7z1801-x64.msi
set cmake=cmake-3.10.2-win64-x64.msi
set python=python-2.7.14.amd64.msi
set qt=qt-unified-windows-x86-online.exe
set vs=vs_Community.exe

if not exist "software" mkdir software 
cd software

if not "%7zip%" exist call :download http://www.7-zip.org/a/%7zip% %7zip%
%7zip% /passive

if not "%cmake%" exist call :download https://cmake.org/files/v3.10/%cmake% %cmake%
%cmake% /passive

if not "%python%" exist call :download https://www.python.org/ftp/python/2.7.14/%python% %python%%
%python% /passive

if not "%qt%" exist call :download https://download.qt.io/official_releases/online_installers/%qt% %qt%
%qt% --script "%wdir%\scripts\qt.qs"|rem

if not "%vs%" exist call :download https://aka.ms/vs/15/release/vs_community.exe %vs%
%vs% --add Microsoft.VisualStudio.Workload.CoreEditor --add Microsoft.Net.Component.4.5.TargetingPack --add Microsoft.Net.Component.4.6.TargetingPack --add Microsoft.VisualStudio.Workload.NativeDesktop --passive --norestart --wait

cd ..
echo Done Installing software.
pause && exit /b

:download
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')"
exit /b