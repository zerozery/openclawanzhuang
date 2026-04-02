@echo off
title OpenClaw Official Installer

echo.
echo ========================================
echo   OpenClaw Official Windows Installer
echo ========================================
echo.
echo This script installs OpenClaw using the official method.
echo See: https://docs.openclaw.ai
echo.
pause

:: Step 1: Check Node.js
echo [1/3] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Node.js is not installed!
    echo Please install Node.js 18+ from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)
echo Node.js version:
node --version
echo.

:: Step 2: Check pnpm
echo [2/3] Checking pnpm...
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo pnpm not found. Installing...
    npm install -g pnpm
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install pnpm
        pause
        exit /b 1
    )
)
echo pnpm version:
pnpm --version
echo.

:: Step 3: Install OpenClaw
echo [3/3] Installing OpenClaw...
set "INSTALL_DIR=%USERPROFILE%\.openclaw"

if not exist "%INSTALL_DIR%" (
    echo Creating directory: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

cd /d "%INSTALL_DIR%"

echo.
echo Running: pnpm create openclaw@latest .
echo This may take 3-5 minutes...
echo.

call pnpm create openclaw@latest .

if %errorlevel% neq 0 (
    echo.
    echo ERROR: OpenClaw installation failed!
    echo Please check your internet connection.
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   OpenClaw Installation Complete!
echo ========================================
echo.
echo Location: %INSTALL_DIR%
echo.
echo To start OpenClaw:
echo   cd %INSTALL_DIR%
echo   openclaw
echo.
echo Or run: openclaw gateway start
echo.
pause

:: Ask to launch
set /p launch="Start OpenClaw now? (y/n): "
if /i "%launch%"=="y" (
    call openclaw
)

pause
