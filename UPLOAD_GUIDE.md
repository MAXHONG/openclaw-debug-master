# 🚀 GitHub 上传指南

## ⚠️ 重要安全提醒

**您刚才在对话中暴露了 GitHub Personal Access Token！**

### 立即行动：
1. 访问 https://github.com/settings/tokens
2. 找到该 Token 并点击 **Delete**
3. 检查安全日志：https://github.com/settings/security-log
4. 如有异常，立即更改密码并启用 2FA

---

## ✅ 安全的上传方式

### 方式 1: GitHub Web 界面（推荐，最安全）

#### 步骤 1: 创建仓库
1. 登录 https://github.com/MAXHONG
2. 点击右上角 **+** → **New repository**
3. 填写信息：
   - **Repository name**: `openclaw-debug-master`
   - **Description**: `A professional system diagnosis and troubleshooting agent for OpenClaw`
   - **Public** ✅
   - **Add a README file** ❌ (我们已经有了)
   - **Choose a license**: MIT License
4. 点击 **Create repository**

#### 步骤 2: 下载打包文件
在您的 VM 上运行：
```bash
cd /tmp/openclaw-debug-master
tar -czf ~/openclaw-debug-master-$(date +%Y%m%d).tar.gz \
  README.md LICENSE install.sh agent/
```

或使用 `gsk` 工具上传到云端：
```bash
# 打包
cd /tmp
tar -czf openclaw-debug-master.tar.gz openclaw-debug-master/

# 使用 gsk 上传（如果可用）
gsk upload openclaw-debug-master.tar.gz
```

#### 步骤 3: 上传文件到 GitHub
1. 在 GitHub 仓库页面，点击 **Add file** → **Upload files**
2. 拖拽以下文件：
   - `README.md`
   - `LICENSE`
   - `install.sh`
   - `agent/` 文件夹（整个目录）
3. Commit message: `Initial commit: Debug Master Agent v2.0.0`
4. 点击 **Commit changes**

---

### 方式 2: Git CLI（本地操作）

⚠️ **不要使用之前暴露的 Token！**

#### 步骤 1: 创建新 Token（最小权限）
1. 访问 https://github.com/settings/tokens/new
2. Note: `OpenClaw Debug Master Upload`
3. Expiration: `7 days`（短期有效）
4. Select scopes: 只勾选 `repo`
5. 点击 **Generate token**
6. **复制 Token**（只显示一次！）

#### 步骤 2: 配置 Git（在 VM 上）
```bash
cd /tmp/openclaw-debug-master

# 初始化仓库
git init
git add .
git commit -m "Initial commit: Debug Master Agent v2.0.0"

# 添加远程仓库
git remote add origin https://github.com/MAXHONG/openclaw-debug-master.git

# 第一次推送
git branch -M main
git push -u origin main
```

当提示输入凭据时：
- **Username**: `MAXHONG`
- **Password**: [粘贴您的新 Token，不是密码！]

#### 步骤 3: 推送成功后立即删除 Token
1. 访问 https://github.com/settings/tokens
2. 删除刚才创建的临时 Token

---

### 方式 3: GitHub CLI（最方便）

#### 步骤 1: 安装 GitHub CLI
```bash
# 已安装 (gh 命令)
gh --version
```

#### 步骤 2: 登录 GitHub
```bash
# 使用浏览器登录（安全）
gh auth login
```

按提示选择：
1. `GitHub.com`
2. `HTTPS`
3. `Login with a web browser`
4. 复制显示的代码，按回车打开浏览器
5. 粘贴代码并授权

#### 步骤 3: 创建并推送仓库
```bash
cd /tmp/openclaw-debug-master

# 创建仓库并推送
gh repo create openclaw-debug-master \
  --public \
  --description "A professional system diagnosis agent for OpenClaw" \
  --source=. \
  --remote=origin \
  --push
```

一条命令完成！

---

## 📂 文件结构

上传后的仓库结构：

```
openclaw-debug-master/
├── README.md                    # 项目主页
├── LICENSE                      # MIT 许可证
├── install.sh                   # 一键安装脚本
└── agent/                       # Agent 文件
    ├── AGENTS.md                # 系统提示词
    ├── agent.json               # Agent 配置
    ├── README.md                # Agent 说明
    ├── QUICK_START.md           # 快速开始
    ├── ADVANCED_USAGE.md        # 高级用法
    ├── FINAL_ANSWER.md          # 核心问题解答
    ├── OPEN_ALTERNATIVES.md     # 开源替代方案
    ├── UPGRADE_SUMMARY.md       # 升级总结
    └── skills/                  # 诊断技能
        ├── service-check.sh
        ├── health-check.sh
        ├── port-check.sh
        ├── app-debug.sh
        ├── analyze-image.sh
        ├── search-web.sh
        ├── crawl-page.sh
        └── remote-diagnose.sh
```

---

## ✅ 上传完成后的检查清单

### 1. 验证仓库
访问 https://github.com/MAXHONG/openclaw-debug-master

应该看到：
- ✅ README.md 正确显示
- ✅ install.sh 存在且可执行
- ✅ agent/ 目录完整
- ✅ LICENSE 文件存在

### 2. 测试安装脚本
在另一台 OpenClaw VM 上测试：
```bash
curl -fsSL https://raw.githubusercontent.com/MAXHONG/openclaw-debug-master/main/install.sh | bash
```

### 3. 添加 GitHub Topics
1. 在仓库页面点击设置（齿轮图标）
2. 添加 Topics:
   - `openclaw`
   - `agent`
   - `debugging`
   - `diagnostics`
   - `troubleshooting`
   - `open-source`

### 4. 创建 Release
1. 点击右侧 **Releases**
2. 点击 **Create a new release**
3. Tag version: `v2.0.0`
4. Release title: `Debug Master Agent v2.0.0 - Initial Release`
5. Description:
```markdown
## 🎉 Initial Release

Debug Master is a professional system diagnosis agent for OpenClaw.

### ✨ Features
- 8 core diagnostic skills
- 100% free & open source tools
- Three-layer self-learning
- Auto-routing support

### 🚀 Quick Install
\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/MAXHONG/openclaw-debug-master/main/install.sh | bash
\`\`\`

### 📚 Documentation
See [README.md](https://github.com/MAXHONG/openclaw-debug-master#readme)
```
6. 上传 `openclaw-debug-master-release.tar.gz`
7. 点击 **Publish release**

---

## 🎯 推广仓库

### 1. 添加到 OpenClaw 社区
- 在 OpenClaw Discord/Slack 分享
- 提交到 OpenClaw Community Skills 列表
- 在 OpenClaw GitHub Discussions 发帖

### 2. 社交媒体
- Twitter/X: 分享项目链接
- Reddit: 发布到 r/opensource, r/selfhosted
- Hacker News: 提交 Show HN

### 3. 添加 README Badge
在 README.md 顶部添加：
```markdown
![GitHub stars](https://img.shields.io/github/stars/MAXHONG/openclaw-debug-master)
![GitHub forks](https://img.shields.io/github/forks/MAXHONG/openclaw-debug-master)
![GitHub issues](https://img.shields.io/github/issues/MAXHONG/openclaw-debug-master)
```

---

## 🔒 安全最佳实践

### ✅ DO（应该做）
- ✅ 使用 GitHub Web 界面上传
- ✅ 使用 GitHub CLI (`gh auth login`)
- ✅ 创建临时 Token（7天有效期）
- ✅ 推送后立即删除 Token
- ✅ 启用 GitHub 2FA
- ✅ 定期检查安全日志

### ❌ DON'T（不要做）
- ❌ 在公开对话中分享 Token
- ❌ 使用长期有效的 Token
- ❌ 给 Token 过多权限
- ❌ 在代码中硬编码 Token
- ❌ 复用同一个 Token

---

## 📞 需要帮助？

如果遇到问题：

1. **GitHub 上传问题**
   - 参考官方文档：https://docs.github.com/en/repositories/creating-and-managing-repositories
   - 使用 GitHub CLI：更简单、更安全

2. **安装脚本问题**
   - 在 GitHub Issues 中报告
   - 提供 OpenClaw 版本和系统信息

3. **功能建议**
   - 在 GitHub Discussions 中讨论
   - 提交 Pull Request

---

## 🎉 完成！

上传完成后，您的项目将：
- ✅ 对全世界开源
- ✅ 其他 OpenClaw 用户可以一键安装
- ✅ 接受社区贡献
- ✅ 持续改进和学习

**项目地址**: https://github.com/MAXHONG/openclaw-debug-master

祝您开源愉快！🚀
