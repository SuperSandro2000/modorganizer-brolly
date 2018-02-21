@echo off
if "%1"=="" set type=RelwithDebInfo
if "%1"=="1" set type=RelwithDebInfo
if "%1"=="type=Debug" set type=RelwithDebInfo
if "%1"=="2" set type=Release
if "%1"=="type=RelwithDebInfo" set type=Release
if "%1"=="3" set type=MinSizeRelease
if "%1"=="type=Release" set type=MinSizeRelease
if "%1"=="4" set type=Debug
if "%1"=="type=MinSizeRelease" set type=Debug
if not "%cd%"=="C:\modorganizer-brolly" echo move me to C:\modorganizer-brolly&& pause && exit /b
:: call scripts\update_source.bat
::if exist build call cmd /c rmdir /s /q %cd%\build
if not exist build mkdir build
cd build
cmake ../src -G "Visual Studio 15 2017 Win64"
"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/Common7/Tools/VsDevCmd.bat" && cd %cd% && msbuild Testing.sln /property:Configuration=%type% && cd.. && pause || pause