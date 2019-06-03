SetLocal EnableDelayedExpansion
@ECHO OFF

SET QR_OUTPUT_DIR=C:\CppProjects\qrencode

IF /i "%PLATFORM%"=="x86" goto x86
IF /i "%PLATFORM%"=="x64" goto x64

echo Platform not supported: %PLATFORM%
goto commonExit

:x86
echo Platform: x86
SET COLLECTION_DIR=Win32
SET PROJECT_PLATFORM=Win32

goto build

:x64
echo Platform: x64
SET COLLECTION_DIR=x64
SET PROJECT_PLATFORM=x64

goto build

:build
@mkdir "%QR_OUTPUT_DIR%\include"
@mkdir "%QR_OUTPUT_DIR%\compile"
@mkdir "%QR_OUTPUT_DIR%\compile\%PLATFORM%"
@mkdir "%QR_OUTPUT_DIR%\compile\%PLATFORM%\Debug"
@mkdir "%QR_OUTPUT_DIR%\compile\%PLATFORM%\Release"

cd qrencode-win32\vc15

echo Building configuration: DEBUG %PLATFORM%
devenv /clean "Debug-Lib|%PROJECT_PLATFORM%" /project qrcodelib qrcode_vc15.sln
IF ERRORLEVEL 1 GOTO errorHandling

devenv /build "Debug-Lib|%PROJECT_PLATFORM%" /project qrcodelib qrcode_vc15.sln
IF ERRORLEVEL 1 GOTO errorHandling

echo Copying "%COLLECTION_DIR%\Debug-Lib\qrcodelib.lib" to "%QR_OUTPUT_DIR%\compile\%PLATFORM%\Debug\"...
xcopy /Y "%COLLECTION_DIR%\Debug-Lib\qrcodelib.lib" "%QR_OUTPUT_DIR%\compile\%PLATFORM%\Debug\"

echo Building configuration: RELEASE %PLATFORM%
devenv /clean "Release-Lib|%PROJECT_PLATFORM%" /project qrcodelib qrcode_vc15.sln
IF ERRORLEVEL 1 GOTO errorHandling

devenv /build "Release-Lib|%PROJECT_PLATFORM%" /project qrcodelib qrcode_vc15.sln
IF ERRORLEVEL 1 GOTO errorHandling

echo Copying "%COLLECTION_DIR%\Release-Lib\qrcodelib.lib" to "%QR_OUTPUT_DIR%\compile\%PLATFORM%\Release\"...
xcopy /Y "%COLLECTION_DIR%\Release-Lib\qrcodelib.lib" "%QR_OUTPUT_DIR%\compile\%PLATFORM%\Release\"

cd ..
echo Copying Headers...
xcopy /Y qrencode.h "%QR_OUTPUT_DIR%\include\"

goto commonExit

:errorHandling
echo Could not compile!
echo More information can be found in the build log files called buildLogRelease.txt and buildLogDebug.txt
echo ********** BUILD FAILURE **********
exit /b 1

:commonExit

echo "Done."