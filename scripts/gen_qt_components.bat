@echo off
set exe="../software/qt-unified-windows-x86-online.exe"
if not exist qt.qs echo qt.qs script missing
if exist qt_log.txt del qt_log.txt
echo %exe%
if exist %exe% (
	echo.
	echo.
	echo.
	echo IMPORTANT
	echo The Installer will say: 
	echo just ignore it and change the install path to C:\Qt2
	echo After the components view you can close the installer,
	echo without installing anything. We got what we need.
	%exe% -v --script qt.qs>>qt_log.txt
) else (
	echo Missing Qt installer %exe%
)

echo All Qt Components are listed in qt_log.txt.
echo Use your favorite text editor to search for
echo this string:     QTCI:  Available components 
echo After that are all components listed.
echo Use this information to modify or update qt.qs
pause && exit /b