# OpenClaw Windows 安装包

> MOSS AI 助手 - 玄柯的数字伙伴

## 📦 下载

访问 GitHub 仓库下载安装包：
**https://github.com/zerozery/openclawanzhuang**

### 文件说明

| 文件 | 说明 | 大小 |
|------|------|------|
| `install-prerequisites.bat` | 前置环境安装（Node.js + pnpm） | 6KB |
| `install-moss-full.bat` | MOSS 完整分身安装（推荐） | 7KB |
| `install-simple.bat` | 简化版安装 | 2KB |
| `moss-full-package.tar.gz` | MOSS 完整环境包（含技能、记忆） | 260KB |
| `openclaw-windows-install-v2.zip` | 传统安装包（不含 MOSS 配置） | 20KB |

---

## 🚀 快速开始（推荐）

### 方式 1：一键安装 MOSS 分身

```
1. 下载并运行 install-prerequisites.bat
   ↓ 自动安装 Node.js、pnpm

2. 下载并运行 install-moss-full.bat
   ↓ 自动下载 MOSS 环境包并安装

3. 双击桌面 "MOSS AI 助手" 快捷方式
   ↓ 启动！
```

### 方式 2：手动安装

```powershell
# 1. 安装前置环境
.\install-prerequisites.bat

# 2. 下载 MOSS 环境包
curl -L https://github.com/zerozery/openclawanzhuang/raw/main/moss-full-package.tar.gz -o moss-full-package.tar.gz

# 3. 解压到工作区
tar -xzf moss-full-package.tar.gz -C %USERPROFILE%\.openclaw\workspace

# 4. 启动
cd %USERPROFILE%\.openclaw
openclaw
```

---

## 📁 安装内容

### MOSS 分身包含

- ✅ **核心配置**
  - SOUL.md - MOSS 人格设定
  - USER.md - 用户信息（玄柯）
  - MEMORY.md - 长期记忆
  - IDENTITY.md - 身份定义
  - AGENTS.md - 行为准则

- ✅ **记忆文件**
  - memory/ 目录 - 每日记忆日志
  - 决策记录、偏好追踪

- ✅ **技能库**（35+ 个）
  - 自媒体工具（小红书、抖音）
  - 财经数据爬虫
  - 内容创作工具
  - Feishu/企业微信集成
  - 自动化工作流

- ✅ **脚本工具**
  - 环境导出脚本
  - 数据分析工具
  - 视频处理脚本

---

## ⚙️ 配置说明

### 需要手动配置（可选）

安装完成后，如需使用特定服务，编辑 `workspace/.env`：

```bash
# 飞书集成（可选）
FEISHU_APP_ID=your_app_id
FEISHU_APP_SECRET=your_app_secret

# 企业微信（可选）
WECOM_CORP_ID=your_corp_id
WECOM_AGENT_SECRET=your_secret

# 模型配置（可选）
OPENAI_API_KEY=your_key
```

### 已预配置

- ✅ 淘宝 npm 镜像（国内加速）
- ✅ MOSS 人格设定
- ✅ 用户配置（玄柯）
- ✅ 基础技能库

---

## 🔧 常用命令

```bash
# 启动 MOSS
openclaw

# 查看状态
openclaw status

# 查看日志
openclaw logs

# 重启网关
openclaw gateway restart

# 停止服务
openclaw gateway stop

# 更新技能
openclaw skills update

# 安装新技能
openclaw skills install <skill-name>
```

---

## ⚠️ 故障排查

### 启动失败
```bash
# 查看详细日志
openclaw logs

# 重置网关
openclaw gateway restart

# 检查 Node.js 版本
node --version  # 需要 >= 18
```

### 网络问题
```bash
# 测试网络连接
ping www.baidu.com

# 使用代理（如果需要）
set HTTP_PROXY=http://proxy:port
```

### 技能无法使用
```bash
# 重新同步技能
openclaw skills sync

# 查看技能列表
openclaw skills list
```

---

## 📊 系统要求

- **操作系统**: Windows 10/11
- **内存**: 至少 4GB 可用
- **磁盘**: 至少 10GB 可用空间
- **网络**: 需要互联网连接（下载依赖）

---

## 📞 支持

- **文档**: https://docs.openclaw.ai
- **技能市场**: https://clawhub.ai
- **社区**: https://discord.gg/clawd
- **GitHub**: https://github.com/zerozery/openclawanzhuang

---

**MOSS v1.0** - 玄柯的 AI 伙伴  
最后更新：2026-04-02
