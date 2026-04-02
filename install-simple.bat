@echo off
chcp 65001 >nul
title OpenClaw 简易安装

echo.
echo ========================================
echo   OpenClaw 简易安装
echo ========================================
echo.

:: 检查 Node.js
echo [1/4] 检查 Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js 未安装！
    echo 请先安装 Node.js: https://nodejs.org/
    echo 下载 LTS 版本，双击安装即可
    pause
    exit /b 1
)
echo ✓ Node.js 已安装
node --version
echo.

:: 安装 pnpm
echo [2/4] 安装 pnpm...
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在安装 pnpm...
    call npm install -g pnpm
    if %errorlevel% neq 0 (
        echo [错误] pnpm 安装失败
        pause
        exit /b 1
    )
)
echo ✓ pnpm 已安装
pnpm --version
echo.

:: 设置 npm 镜像
echo [3/4] 设置 npm 镜像（淘宝）...
call npm config set registry https://registry.npmmirror.com/
echo ✓ 镜像已设置
echo.

:: 安装 OpenClaw
echo [4/4] 安装 OpenClaw...
set "INSTALL_DIR=%USERPROFILE%\.openclaw"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
cd /d "%INSTALL_DIR%"

echo 正在安装（可能需要 2-5 分钟）...
call pnpm create openclaw@latest .
if %errorlevel% neq 0 (
    echo.
    echo [错误] 安装失败
    echo 可能是网络问题，请重试或检查网络
    pause
    exit /b 1
)

echo.
echo ========================================
echo   安装完成！
echo ========================================
echo.
echo 安装位置：%INSTALL_DIR%
echo.
echo 启动命令：
echo   cd %INSTALL_DIR%
echo   openclaw
echo.
echo 或者双击桌面的 start-openclaw.bat（如果有）
echo.
pause
