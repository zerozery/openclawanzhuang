@echo off
title OpenClaw Setup

echo.
echo ========================================
echo   OpenClaw Prerequisites Installer
echo ========================================
echo.

:: Check current directory
echo Current directory: %~dp0
echo.

:: Pause to let user see the window
pause

:: Check Node.js
echo [1/4] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Node.js is already installed
    node --version
) else (
    echo Node.js not found. Installing...
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo Download LTS version and double-click to install
    echo.
    pause
    node --version >nul 2>&1
    if errorlevel 1 (
        echo Error: Node.js still not found. Please install it first.
        pause
        exit /b 1
    )
)
echo.

:: Set npm registry
echo [2/4] Setting npm registry...
npm config set registry https://registry.npmmirror.com/
echo Done.
echo.

:: Install pnpm
echo [3/4] Installing pnpm...
pnpm --version >nul 2>&1
if %errorlevel% equ 0 (
    echo pnpm is already installed
    pnpm --version
) else (
    echo Installing pnpm...
    call npm install -g pnpm
    if errorlevel 1 (
        echo Error: Failed to install pnpm
        pause
        exit /b 1
    )
    echo pnpm installed successfully
    pnpm --version
)
echo.

:: Check Git (optional)
echo [4/4] Checking Git (optional)...
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Git is installed
    git --version
) else (
    echo Git not found (optional, can install later)
)
echo.

:: Done
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo Next step: Run install-moss-full.bat
echo.
pause
