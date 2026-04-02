# MOSS 分身安装指南

## 📦 完整安装包内容

下载整个文件夹到 Windows 电脑，包含以下文件：

```
openclaw-install/
├── install-prerequisites.bat      # 第 1 步：安装前置环境
├── install-moss-full.bat          # 第 2 步：安装 MOSS 分身
├── install-simple.bat             # 简化版安装（备选）
├── moss-full-package.tar.gz       # MOSS 完整环境包（260KB）
├── openclaw-windows-install-v2.zip # 传统安装包（可选）
├── README.md                      # 说明文档
└── INSTALL-GUIDE.md               # 本指南
```

---

## 🚀 安装步骤

### 第 1 步：安装前置环境

**双击运行** `install-prerequisites.bat`

这个脚本会：
- ✅ 检查 Windows 版本（需要 Win10/11）
- ✅ 检查网络连接
- ✅ 安装 Node.js 18+（使用 winget 或手动）
- ✅ 安装 pnpm（包管理器）
- ✅ 安装 Git（可选）
- ✅ 设置 npm 淘宝镜像

**预计时间**：3-5 分钟

完成后会看到：
```
========================================
  前置环境安装完成！
========================================
✓ Node.js: v20.x.x
✓ pnpm: 8.x.x
✓ Git: 2.x.x（如果安装了）
```

---

### 第 2 步：安装 MOSS 分身

**双击运行** `install-moss-full.bat`

⚠️ **重要**：确保 `moss-full-package.tar.gz` 文件与安装脚本在**同一文件夹**！

这个脚本会：
- ✅ 检查 Node.js 和 pnpm 已安装
- ✅ 安装 OpenClaw 框架（使用 pnpm）
- ✅ **从本地加载** `moss-full-package.tar.gz`
- ✅ 解压到工作区
- ✅ 创建启动脚本
- ✅ 创建桌面快捷方式（可选）

**预计时间**：5-8 分钟

完成后会看到：
```
========================================
  MOSS 分身安装完成！
========================================
📍 安装位置：C:\Users\你的用户名\.openclaw
📁 工作区：C:\Users\你的用户名\.openclaw\workspace
```

---

### 第 3 步：启动 MOSS

安装完成后会问：
```
是否现在启动 MOSS？(y/n):
```

输入 `y` 直接启动，或者：

**方式 1：双击桌面快捷方式**
- 桌面会出现 "MOSS AI 助手" 图标
- 双击即可启动

**方式 2：运行启动脚本**
```
C:\Users\你的用户名\.openclaw\start-moss.bat
```

**方式 3：命令行启动**
```cmd
cd %USERPROFILE%\.openclaw
openclaw
```

---

## 📁 安装后结构

```
C:\Users\你的用户名\.openclaw\
├── workspace/              # MOSS 工作区
│   ├── SOUL.md            # 人格设定
│   ├── USER.md            # 用户信息
│   ├── MEMORY.md          # 长期记忆
│   ├── memory/            # 每日记忆日志
│   ├── skills/            # 35+ 个技能
│   └── scripts/           # 脚本工具
├── agents/                # Agent 配置
├── extensions/            # 扩展插件
├── start-moss.bat         # 启动脚本
└── openclaw.json          # 主配置
```

---

## ⚠️ 注意事项

### 必须满足的条件

1. **Windows 10 或更高版本**
   - Windows 7/8 可能不兼容
   - 需要支持 `tar` 命令（Win10 1803+ 自带）

2. **网络连接**
   - 第 1 步需要下载 Node.js（约 30MB）
   - 第 2 步需要下载 OpenClaw（约 50MB）
   - `moss-full-package.tar.gz` 已包含在文件夹中，无需下载

3. **磁盘空间**
   - 至少需要 10GB 可用空间
   - 安装后约占 2-3GB

---

## 🆘 故障排查

### 问题 1：Node.js 安装失败

**症状**：winget 无法使用或下载超时

**解决**：
1. 手动下载 Node.js：https://nodejs.org/
2. 选择 LTS 版本（绿色按钮）
3. 双击安装包，一直点 Next
4. 重新运行 `install-prerequisites.bat`

---

### 问题 2：找不到 moss-full-package.tar.gz

**症状**：运行 `install-moss-full.bat` 时报错

**解决**：
1. 确保 `moss-full-package.tar.gz` 与安装脚本在**同一文件夹**
2. 文件名必须完全一致（区分大小写）
3. 不要重命名该文件

---

### 问题 3：tar 解压失败

**症状**：Windows 版本过低，不支持 tar 命令

**解决**：
1. 使用 7-Zip 或 WinRAR 手动解压 `moss-full-package.tar.gz`
2. 将解压后的文件夹内容复制到：
   ```
   C:\Users\你的用户名\.openclaw\workspace\
   ```
3. 然后继续运行安装脚本

---

### 问题 4：启动失败

**症状**：双击快捷方式没反应

**解决**：
```cmd
# 打开命令行
cd %USERPROFILE%\.openclaw
openclaw logs

# 查看日志，找出错误原因

# 重启网关
openclaw gateway restart
```

---

## 📊 安装时间估算

| 步骤 | 网络良好 | 网络一般 | 离线 |
|------|----------|----------|------|
| 第 1 步：前置环境 | 3-5 分钟 | 5-10 分钟 | - |
| 第 2 步：MOSS 分身 | 5-8 分钟 | 8-15 分钟 | 3-5 分钟 |
| **总计** | **10-15 分钟** | **15-25 分钟** | **3-5 分钟** |

---

## ✅ 验证安装

安装完成后，运行以下命令验证：

```cmd
# 1. 检查 OpenClaw 版本
openclaw --version

# 2. 查看状态
openclaw status

# 3. 查看技能列表
openclaw skills list

# 4. 测试对话
openclaw
# 然后输入：你好
```

如果看到 MOSS 的回复，说明安装成功！🎉

---

## 📞 需要帮助？

- **GitHub 仓库**：https://github.com/zerozery/openclawanzhuang
- **OpenClaw 文档**：https://docs.openclaw.ai
- **技能市场**：https://clawhub.ai

---

**MOSS v1.0** - 玄柯的 AI 伙伴  
最后更新：2026-04-02
