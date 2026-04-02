@echo off
title OpenClaw 前置环境安装

:: 防止窗口一闪而过
if "%~1"=="-test" (
    echo [测试模式] 脚本开始运行...
)

:: 尝试设置 UTF-8 编码（失败也不影响）
chcp 65001 >nul 2>&1

echo.
echo ========================================
echo   OpenClaw 前置环境安装
echo ========================================
echo.
echo 本脚本将自动安装：
echo   - Node.js (LTS 版本)
echo   - pnpm (包管理器)
echo   - Git (可选，用于版本控制)
echo.

:: 检查是否在正确的目录
echo [检查] 当前目录：%~dp0
echo [检查] 脚本路径：%~f0
echo.

set /p startInstall="是否开始安装？(y/n): "
if /i not "%startInstall%"=="y" (
    echo 安装已取消
    pause
    exit /b 0
)

setlocal EnableDelayedExpansion
set "INSTALL_DIR=%USERPROFILE%\.openclaw"

:: ========================================
:: 步骤 1: 检查操作系统
:: ========================================
echo [1/6] 检查操作系统...
echo ----------------------------------------
ver | findstr /i "10." >nul
if errorlevel 1 (
    ver | findstr /i "11." >nul
    if errorlevel 1 (
        echo [警告] 建议使用 Windows 10 或更高版本
        echo 当前系统可能不兼容
        set /p continue="是否继续？(y/n): "
        if /i not "%continue%"=="y" (
            echo 安装已取消
            pause
            exit /b 1
        )
    ) else (
        echo ✓ Windows 11 检测到
    )
) else (
    echo ✓ Windows 10 检测到
)
echo.

:: ========================================
:: 步骤 2: 检查网络连接
:: ========================================
echo [2/6] 检查网络连接...
echo ----------------------------------------
echo 正在测试网络连接...
ping -n 2 www.baidu.com >nul 2>&1
if errorlevel 1 (
    echo [错误] 网络连接失败
    echo 请检查网络后重试
    pause
    exit /b 1
)
echo ✓ 网络连接正常
echo.

:: ========================================
:: 步骤 3: 安装 Node.js
:: ========================================
echo [3/6] 检查 Node.js...
echo ----------------------------------------
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('node --version') do set NODE_VERSION=%%i
    echo ✓ Node.js 已安装：%NODE_VERSION%
    
    :: 检查版本是否 >= 18
    for /f "tokens=1,2 delims=." %%a in ('node --version ^| findstr /r "^v[0-9]"') do (
        set /a major=%%a
        if !major! LSS 18 (
            echo [警告] Node.js 版本过低，建议升级到 18.x 或更高
            set /p upgrade="是否升级？(y/n): "
            if /i "!upgrade!"=="y" goto :install_node
        )
    )
) else (
    echo Node.js 未安装，正在安装...
    
    :install_node
    echo.
    echo 方式 1: 使用 winget 自动安装（推荐）
    echo 方式 2: 手动下载安装
    echo.
    set /p installMethod="请选择安装方式 (1/2): "
    
    if "!installMethod!"=="1" (
        echo 正在使用 winget 安装 Node.js LTS...
        winget install OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements --silent
        if %errorlevel% neq 0 (
            echo [警告] winget 安装失败，尝试手动安装
            goto :manual_node
        )
        echo ✓ Node.js 安装完成
        :: 刷新 PATH
        set "PATH=%PATH%;C:\Program Files\nodejs"
    ) else (
        :manual_node
        echo.
        echo 请手动安装 Node.js:
        echo 1. 访问：https://nodejs.org/
        echo 2. 下载 LTS 版本（绿色按钮）
        echo 3. 双击安装包，一直点 Next
        echo.
        pause
        echo 安装完成后按任意键继续...
        pause >nul
        node --version >nul 2>&1
        if errorlevel 1 (
            echo [错误] 未检测到 Node.js，请重新运行本脚本
            pause
            exit /b 1
        )
    )
    
    for /f "delims=" %%i in ('node --version') do set NODE_VERSION=%%i
    echo ✓ Node.js 已安装：%NODE_VERSION%
)
echo.

:: ========================================
:: 步骤 4: 设置 npm 镜像
:: ========================================
echo [4/6] 配置 npm 镜像...
echo ----------------------------------------
echo 当前 npm 镜像：
call npm config get registry
echo.
echo 正在设置为淘宝镜像（国内更快）...
call npm config set registry https://registry.npmmirror.com/
echo ✓ npm 镜像已设置为：https://registry.npmmirror.com/
echo.

:: ========================================
:: 步骤 5: 安装 pnpm
:: ========================================
echo [5/6] 检查 pnpm...
echo ----------------------------------------
pnpm --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('pnpm --version') do set PNPM_VERSION=%%i
    echo ✓ pnpm 已安装：%PNPM_VERSION%
) else (
    echo pnpm 未安装，正在通过 npm 安装...
    call npm install -g pnpm
    if %errorlevel% neq 0 (
        echo [错误] pnpm 安装失败
        echo 请手动运行：npm install -g pnpm
        pause
        exit /b 1
    )
    for /f "delims=" %%i in ('pnpm --version') do set PNPM_VERSION=%%i
    echo ✓ pnpm 已安装：%PNPM_VERSION%
)
echo.

:: ========================================
:: 步骤 6: 检查 Git（可选）
:: ========================================
echo [6/6] 检查 Git（可选）...
echo ----------------------------------------
git --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('git --version') do set GIT_VERSION=%%i
    echo ✓ Git 已安装：%GIT_VERSION%
) else (
    echo Git 未安装（可选，用于版本控制和技能管理）
    echo.
    set /p installGit="是否安装 Git？(y/n): "
    if /i "%installGit%"=="y" (
        echo 正在使用 winget 安装 Git...
        winget install Git.Git -e --accept-package-agreements --accept-source-agreements --silent
        if %errorlevel% equ 0 (
            echo ✓ Git 安装完成
            set "PATH=%PATH%;C:\Program Files\Git\cmd"
        ) else (
            echo [警告] Git 安装失败，可稍后手动安装
            echo 下载地址：https://git-scm.com/download/win
        )
    ) else (
        echo 跳过 Git 安装
    )
)
echo.

:: ========================================
:: 完成
:: ========================================
echo ========================================
echo   前置环境安装完成！
echo ========================================
echo.
echo ✓ Node.js: %NODE_VERSION%
echo ✓ pnpm: %PNPM_VERSION%
if defined GIT_VERSION echo ✓ Git: %GIT_VERSION%
echo.
echo 接下来请运行安装脚本：
echo   install-openclaw-enhanced.bat
echo 或
echo   install-simple.bat
echo.
echo 或者直接运行：
echo   call pnpm create openclaw@latest "%INSTALL_DIR%"
echo.
pause
