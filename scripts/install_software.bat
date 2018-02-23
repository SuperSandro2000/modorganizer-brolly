@echo off
:: wmic path win32_process Where "CommandLine Like '%%/c ""C:\\Program Files\\LLVM/tools/msbuild/install.bat%%'" Call Terminate
:: Working directory. Do not change or stuff will probably break
set wdir=C:\modorganizer-brolly

:: get Admin rights
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
echo UAC.ShellExecute "cmd.exe", "/c cd %cd% && install_software.bat", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
:: inform user about C:\Qt folder exists and what to do
if exist "C:\Qt" (
	echo C:\Qt folder found. Please uninstall it
	echo or manually install the required packages
)

:: set executable file names. URLs can change with every release and are simply changed in call: download
set sevenzip=7z1801-x64.msi
set cmake=cmake-3.10.2-win64-x64.msi
set llvm=LLVM-5.0.1-win64.exe
set perl=strawberry-perl-5.26.1.1-64bit.msi
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

REM if not exist "%llvm%" call :download "http://releases.llvm.org/5.0.1/%llvm%" %llvm%
REM echo Installing LLVM...
REM :: kill the CMD Windows about MSVC integration
REM start ..\scripts\LLVM_kill.bat
REM %llvm% /S
REM echo Adding LLVM to PATH...
REM setx /M PATH "%PATH%;C:\Program Files\LLVM\bin" 
REM :: create a empty file to stop the LLVM_kill.bat script
REM copy /y nul ..\scripts\LLVM

if not exist "%perl%" call :download "http://strawberryperl.com/download/5.26.1.1/%perl%" %perl%
echo Installing Strawberry Perl...
%perl% /passive

if not exist "%python%" call :download "https://www.python.org/ftp/python/2.7.14/%python%" %python%
echo Installing Python...
%python% /passive INSTALLLEVEL=1 ADDLOCAL=DefaultFeature,SharedCRT,Extensions,TclTk,Documentation,Tools,pip_feature,Testsuite,PrependPath

if not exist "C:\Qt" (
	if not exist "%qt%" call :download "https://download.qt.io/official_releases/online_installers/%qt%" %qt%
	echo Installing Qt...
	:: | rem is a workaround to wait until Qt is done with installing
	%qt% --script "%wdir%\scripts\qt.qs"|rem
	:: rename a fodler that keeps us from compiling
	ren C:\Qt\5.10.0\msvc2017_64\include\QtNfc QtNfc.disable
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