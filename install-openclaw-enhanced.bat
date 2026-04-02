@echo off
chcp 65001 >nul
title OpenClaw Windows 一键安装（增强版）

echo.
echo ========================================
echo   OpenClaw Windows 一键安装（增强版）
echo ========================================
echo.

:: 先运行前置环境安装
echo [准备] 检查并安装前置环境...
echo ----------------------------------------
if exist "%~dp0install-prerequisites.bat" (
    echo 正在运行前置环境安装...
    call "%~dp0install-prerequisites.bat"
    if %errorlevel% neq 0 (
        echo [错误] 前置环境安装失败
        pause
        exit /b 1
    )
    echo.
    echo 前置环境安装完成，继续安装 OpenClaw...
    echo.
) else (
    echo [警告] 未找到前置环境安装脚本
    echo 请确保所有脚本在同一目录下
    echo.
)

:: 检查 Node.js
echo [1/7] 检查 Node.js...
echo ----------------------------------------
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Node.js 未安装
    echo 请先运行 install-prerequisites.bat
    pause
    exit /b 1
)
for /f "delims=" %%i in ('node --version') do set NODE_VERSION=%%i
echo ✓ Node.js: %NODE_VERSION%
echo.

:: 检查 pnpm
echo [2/7] 检查 pnpm...
echo ----------------------------------------
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] pnpm 未安装
    echo 请先运行 install-prerequisites.bat
    pause
    exit /b 1
)
for /f "delims=" %%i in ('pnpm --version') do set PNPM_VERSION=%%i
echo ✓ pnpm: %PNPM_VERSION%
echo.

:: 设置 npm 镜像
echo [3/7] 配置 npm 镜像...
echo ----------------------------------------
call npm config set registry https://registry.npmmirror.com/
echo ✓ 已设置淘宝镜像
echo.

:: 创建安装目录
echo [4/7] 创建安装目录...
echo ----------------------------------------
set "INSTALL_DIR=%USERPROFILE%\.openclaw"
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
    echo ✓ 目录已创建：%INSTALL_DIR%
) else (
    echo ✓ 目录已存在：%INSTALL_DIR%
)
echo.

:: 备份现有配置
if exist "%INSTALL_DIR%\.env" (
    echo [提示] 检测到现有配置，正在备份...
    set "BACKUP_DIR=%INSTALL_DIR%\backup_%date:~0,4%%date:~5,2%%date:~8,2%"
    if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
    copy "%INSTALL_DIR%\.env" "%BACKUP_DIR%\" >nul 2>&1
    copy "%INSTALL_DIR%\config.json" "%BACKUP_DIR%\" >nul 2>&1
    echo ✓ 配置已备份到：%BACKUP_DIR%
    echo.
)

:: 安装 OpenClaw
echo [5/7] 安装 OpenClaw...
echo ----------------------------------------
cd /d "%INSTALL_DIR%"

if exist "%INSTALL_DIR%\node_modules\openclaw" (
    echo [提示] 检测到已安装的 OpenClaw
    echo.
    echo 选择操作：
    echo   1 - 更新
    echo   2 - 重新安装
    echo   3 - 取消
    echo.
    set /p action="请输入选项 (1/2/3): "
    
    if "%action%"=="1" (
        echo 正在更新 OpenClaw...
        call pnpm update openclaw
        echo ✓ OpenClaw 更新完成
    ) else if "%action%"=="2" (
        echo 正在重新安装 OpenClaw...
        rmdir /s /q "%INSTALL_DIR%\node_modules"
        call pnpm create openclaw@latest .
        echo ✓ OpenClaw 重新安装完成
    ) else (
        echo 安装已取消
        pause
        exit /b 0
    )
) else (
    echo 正在安装 OpenClaw（可能需要 2-5 分钟）...
    call pnpm create openclaw@latest .
    if %errorlevel% neq 0 (
        echo.
        echo [错误] OpenClaw 安装失败
        echo 可能是网络问题，请重试
        pause
        exit /b 1
    )
    echo ✓ OpenClaw 安装完成
)
echo.

:: 配置环境变量
echo [6/7] 配置环境变量...
echo ----------------------------------------
set "PATH=%PATH%;%INSTALL_DIR%\node_modules\.bin"
echo ✓ 环境变量已配置（当前会话）
echo.

:: 创建启动脚本
echo [7/7] 创建启动脚本...
echo ----------------------------------------
set "START_SCRIPT=%INSTALL_DIR%\start.bat"
echo @echo off > "%START_SCRIPT%"
echo chcp 65001 ^>nul >> "%START_SCRIPT%"
echo cd /d "%INSTALL_DIR%" >> "%START_SCRIPT%"
echo openclaw >> "%START_SCRIPT%"
echo ✓ 启动脚本已创建：%START_SCRIPT%
echo.

:: 完成
echo ========================================
echo   安装完成！
echo ========================================
echo.
echo 🎉 OpenClaw 已成功安装！
echo.
echo 📍 安装位置：%INSTALL_DIR%
echo.
echo 📋 快速开始：
echo   1. 双击运行：%START_SCRIPT%
echo   2. 或命令行：cd %INSTALL_DIR% ^&^& openclaw
echo.
echo 📚 资源：
echo   - 文档：https://docs.openclaw.ai
echo   - 技能市场：https://clawhub.ai
echo   - 社区：https://discord.gg/clawd
echo.

:: 询问是否启动
set /p launch="是否现在启动 OpenClaw？(y/n): "
if /i "%launch%"=="y" (
    cd /d "%INSTALL_DIR%"
    call openclaw
) else (
    echo.
    echo ✓ 稍后双击 %START_SCRIPT% 即可启动
)

echo.
pause
