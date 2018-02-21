@echo off
echo Watching for Error about MSVC Integration
cd ..\scripts
ping 127.0.0.1 -n 20 > nul
:start
ping 127.0.0.1 -n 4 > nul
>nul 2>&1 wmic path win32_process Where "CommandLine Like '%%/c ""C:\\Program Files\\LLVM/tools/msbuild/install.bat%%'" Call Terminate
if exist LLVM del LLVM && exit
goto start