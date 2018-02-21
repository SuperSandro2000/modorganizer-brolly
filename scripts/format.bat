@echo off
cd ..\src
for /r %%v in (*.cpp,*.cxx,*.h) do clang-format -i %%v
echo All formated
pause