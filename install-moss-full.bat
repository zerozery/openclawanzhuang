@echo off
title MOSS 分身完整安装

:: 防止窗口一闪而过
if "%~1"=="-test" (
    echo [测试模式] 脚本开始运行...
)

:: 尝试设置 UTF-8 编码（失败也不影响）
chcp 65001 >nul 2>&1

echo.
echo ========================================
echo   MOSS AI 分身 - 完整安装
echo ========================================
echo.
echo 正在安装 MOSS（玄柯的 AI 伙伴）到本机...
echo.

:: 检查是否在正确的目录
echo [检查] 当前目录：%~dp0
echo [检查] 脚本路径：%~f0
echo.

:: 检查 moss-full-package.tar.gz 是否存在
set "PACKAGE_FILE=%~dp0moss-full-package.tar.gz"
if exist "%PACKAGE_FILE%" (
    echo ✓ 找到环境包：%PACKAGE_FILE%
) else (
    echo [错误] 未找到 moss-full-package.tar.gz
    echo 位置：%PACKAGE_FILE%
    echo.
    echo 请确保此文件与安装脚本在同一文件夹
    echo.
    pause
    exit /b 1
)

set /p startInstall="是否开始安装？(y/n): "
if /i not "%startInstall%"=="y" (
    echo 安装已取消
    pause
    exit /b 0
)

setlocal EnableDelayedExpansion

:: 检查前置环境
echo [准备] 检查前置环境...
echo ----------------------------------------
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Node.js
    echo 请先运行：install-prerequisites.bat
    pause
    exit /b 1
)
echo ✓ Node.js 已安装
node --version

pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 pnpm
    echo 请先运行：install-prerequisites.bat
    pause
    exit /b 1
)
echo ✓ pnpm 已安装
pnpm --version
echo.

:: 设置 npm 镜像
echo [1/6] 配置 npm 镜像...
echo ----------------------------------------
call npm config set registry https://registry.npmmirror.com/
echo ✓ 已设置淘宝镜像
echo.

:: 创建安装目录
echo [2/6] 创建安装目录...
echo ----------------------------------------
set "INSTALL_DIR=%USERPROFILE%\.openclaw"
if exist "%INSTALL_DIR%" (
    echo [提示] 检测到现有安装
    set /p overwrite="是否覆盖安装？(y/n): "
    if /i not "%overwrite%"=="y" (
        echo 安装已取消
        pause
        exit /b 0
    )
    echo 正在备份现有配置...
    set "BACKUP_DIR=%INSTALL_DIR%\backup_%date:~0,4%%date:~5,2%%date:~8,2%"
    if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
    xcopy "%INSTALL_DIR%\workspace" "%BACKUP_DIR%\workspace" /E /I /Y >nul 2>&1
    echo ✓ 配置已备份到：%BACKUP_DIR%
)

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
echo ✓ 安装目录：%INSTALL_DIR%
echo.

:: 安装 OpenClaw 框架
echo [3/6] 安装 OpenClaw 框架...
echo ----------------------------------------
cd /d "%INSTALL_DIR%"
echo 正在安装（可能需要 3-5 分钟）...
call pnpm create openclaw@latest .
if %errorlevel% neq 0 (
    echo.
    echo [错误] OpenClaw 安装失败
    echo 请检查网络连接后重试
    pause
    exit /b 1
)
echo ✓ OpenClaw 框架安装完成
echo.

:: 加载 MOSS 完整环境包
echo [4/6] 加载 MOSS 完整环境包...
echo ----------------------------------------
set "WORKSPACE_DIR=%INSTALL_DIR%\workspace"
set "PACKAGE_FILE=%~dp0moss-full-package.tar.gz"

:: 检查本地是否有压缩包
if exist "%PACKAGE_FILE%" (
    echo ✓ 找到本地环境包：%PACKAGE_FILE%
) else (
    echo [错误] 未找到 moss-full-package.tar.gz
    echo 请确保此文件与安装脚本在同一文件夹
    echo.
    echo 下载地址：https://github.com/zerozery/openclawanzhuang
    pause
    exit /b 1
)

echo.
echo 正在解压到工作区...
if not exist "%WORKSPACE_DIR%" mkdir "%WORKSPACE_DIR%"

:: 创建临时解压目录
set "EXTRACT_DIR=%TEMP%\moss-extract"
if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%"
mkdir "%EXTRACT_DIR%"

:: 使用 tar 解压（Windows 10+ 支持）
tar -xf "%PACKAGE_FILE%" -C "%EXTRACT_DIR%"
if %errorlevel% neq 0 (
    echo [警告] tar 解压失败
    pause
    exit /b 1
)

:: 查找解压后的文件夹并复制
for /d %%i in ("%EXTRACT_DIR%\*") do (
    echo 正在复制文件到工作区...
    xcopy "%%i\*" "%WORKSPACE_DIR%\" /E /I /Y >nul 2>&1
)

if %errorlevel% equ 0 (
    echo ✓ 文件已解压到工作区
) else (
    echo [警告] 文件复制失败
)

:: 清理临时文件
rmdir /s /q "%EXTRACT_DIR%" >nul 2>&1

echo.

:: 创建 memory 目录
echo [5/6] 创建记忆目录...
echo ----------------------------------------
if not exist "%WORKSPACE_DIR%\memory" mkdir "%WORKSPACE_DIR%\memory"
echo ✓ memory 目录已创建
echo.

:: 创建启动脚本
echo [6/6] 创建启动脚本...
echo ----------------------------------------

:: 创建 start-moss.bat
set "START_SCRIPT=%INSTALL_DIR%\start-moss.bat"
echo @echo off > "%START_SCRIPT%"
echo chcp 65001 ^>nul >> "%START_SCRIPT%"
echo title MOSS AI 助手 >> "%START_SCRIPT%"
echo. >> "%START_SCRIPT%"
echo echo ======================================== >> "%START_SCRIPT%"
echo echo   MOSS AI 助手 - 玄柯的伙伴 >> "%START_SCRIPT%"
echo echo ======================================== >> "%START_SCRIPT%"
echo echo. >> "%START_SCRIPT%"
echo cd /d "%INSTALL_DIR%" >> "%START_SCRIPT%"
echo call openclaw >> "%START_SCRIPT%"
echo. >> "%START_SCRIPT%"
echo ✓ 启动脚本已创建：%START_SCRIPT%

:: 创建桌面快捷方式
echo.
set /p createShortcut="是否创建桌面快捷方式？(y/n): "
if /i "%createShortcut%"=="y" (
    powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut($env:USERPROFILE + '\Desktop\MOSS AI 助手.lnk'); $Shortcut.TargetPath = '%START_SCRIPT%'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'MOSS - 玄柯的 AI 伙伴'; $Shortcut.Save()"
    if %errorlevel% equ 0 (
        echo ✓ 桌面快捷方式已创建
    ) else (
        echo [警告] 快捷方式创建失败，可手动创建
    )
)
echo.

:: 完成
echo ========================================
echo   MOSS 分身安装完成！
echo ========================================
echo.
echo 🎉 MOSS 已成功安装到本机！
echo.
echo 📍 安装位置：%INSTALL_DIR%
echo 📁 工作区：%WORKSPACE_DIR%
echo.
echo 📋 快速开始：
echo   1. 双击桌面 "MOSS AI 助手" 快捷方式
echo   2. 或运行：%START_SCRIPT%
echo   3. 或命令行：cd %INSTALL_DIR% ^&^& openclaw
echo.
echo 🧠 MOSS 的人格和记忆已配置完成
echo 📚 技能库需要手动下载（见 GitHub）
echo.
echo ⚠️  首次启动较慢，请耐心等待初始化
echo.

:: 询问是否启动
set /p launch="是否现在启动 MOSS？(y/n): "
if /i "%launch%"=="y" (
    cd /d "%INSTALL_DIR%"
    call openclaw
) else (
    echo.
    echo ✓ 稍后双击快捷方式即可启动
)

echo.
echo 🌿 MOSS 随时为你服务！
echo.
pause
