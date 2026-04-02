@echo off
title MOSS AI Setup

echo.
echo ========================================
echo   MOSS AI Full Installer
echo ========================================
echo.

:: Check current directory
echo Current directory: %~dp0
echo.

:: Check if package file exists
set "PACKAGE_FILE=%~dp0moss-full-package.tar.gz"
if not exist "%PACKAGE_FILE%" (
    echo ERROR: moss-full-package.tar.gz not found!
    echo Location: %PACKAGE_FILE%
    echo.
    echo Please make sure this file is in the same folder as the installer.
    echo.
    pause
    exit /b 1
)
echo Found package file: %PACKAGE_FILE%
echo.

:: Pause to let user see
pause

:: Check Node.js
echo [1/5] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found!
    echo Please run install-prerequisites.bat first
    pause
    exit /b 1
)
echo Node.js: 
node --version
echo.

:: Check pnpm
echo [2/5] Checking pnpm...
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: pnpm not found!
    echo Please run install-prerequisites.bat first
    pause
    exit /b 1
)
echo pnpm: 
pnpm --version
echo.

:: Set npm registry
echo [3/5] Setting npm registry...
npm config set registry https://registry.npmmirror.com/
echo Done.
echo.

:: Install OpenClaw
echo [4/5] Installing OpenClaw...
set "INSTALL_DIR=%USERPROFILE%\.openclaw"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
cd /d "%INSTALL_DIR%"

echo Installing OpenClaw (this may take 3-5 minutes)...
call pnpm create openclaw@latest .
if errorlevel 1 (
    echo.
    echo ERROR: OpenClaw installation failed!
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)
echo OpenClaw installed successfully.
echo.

:: Extract MOSS package
echo [5/5] Extracting MOSS package...
set "WORKSPACE_DIR=%INSTALL_DIR%\workspace"
if not exist "%WORKSPACE_DIR%" mkdir "%WORKSPACE_DIR%"

:: Create temp directory
set "EXTRACT_DIR=%TEMP%\moss-extract"
if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%"
mkdir "%EXTRACT_DIR%"

:: Extract tar.gz
echo Extracting package...
tar -xf "%PACKAGE_FILE%" -C "%EXTRACT_DIR%"
if errorlevel 1 (
    echo ERROR: Failed to extract package
    pause
    exit /b 1
)

:: Copy files to workspace
for /d %%i in ("%EXTRACT_DIR%\*") do (
    echo Copying files to workspace...
    xcopy "%%i\*" "%WORKSPACE_DIR%\" /E /I /Y >nul 2>&1
)

:: Cleanup
rmdir /s /q "%EXTRACT_DIR%" >nul 2>&1
echo MOSS package extracted successfully.
echo.

:: Create start script
echo Creating start script...
echo @echo off > "%INSTALL_DIR%\start-moss.bat"
echo title MOSS AI Assistant >> "%INSTALL_DIR%\start-moss.bat"
echo cd /d "%INSTALL_DIR%" >> "%INSTALL_DIR%\start-moss.bat"
echo openclaw >> "%INSTALL_DIR%\start-moss.bat"
echo Start script created: %INSTALL_DIR%\start-moss.bat
echo.

:: Done
echo ========================================
echo   MOSS Installation Complete!
echo ========================================
echo.
echo Installation location: %INSTALL_DIR%
echo.
echo To start MOSS:
echo   1. Double-click: %INSTALL_DIR%\start-moss.bat
echo   2. Or run: cd %INSTALL_DIR% ^&^& openclaw
echo.

:: Ask to launch
set /p launch="Start MOSS now? (y/n): "
if /i "%launch%"=="y" (
    cd /d "%INSTALL_DIR%"
    call openclaw
) else (
    echo.
    echo You can start MOSS later by double-clicking start-moss.bat
)

echo.
pause
