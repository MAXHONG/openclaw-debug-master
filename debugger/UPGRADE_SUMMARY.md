# Debug Master Agent - 开源升级总结

## 🎯 核心改进

### 问题 1: GSK 工具依赖性
**原问题**: GSK CLI 是 Genspark 私有服务，需要 API Key 且可能产生费用

**解决方案**: 100% 替换为开源工具

| 功能 | 原方案 (GSK) | 新方案 (开源) | 成本 |
|------|-------------|--------------|------|
| 图像分析 | `gsk analyze` | Tesseract OCR + Ollama LLaVA | **免费** |
| 网页搜索 | `gsk search` | DuckDuckGo API | **免费** |
| 网页抓取 | `gsk crawl` | wget + html2text | **免费** |
| 文档摘要 | `gsk summarize` | Ollama Qwen2 | **免费** |
| 远程诊断 | 手动 SSH | 自动化脚本 | **免费** |

---

### 问题 2: Agent 缺乏自主学习能力
**原问题**: Agent 遇到陌生问题时只能报告"无法处理"

**解决方案**: 实现三层学习机制

#### 第 1 层: 搜索解决方案
```bash
# Agent 遇到陌生错误时
bash skills/search-web.sh "具体错误信息"
bash skills/crawl-page.sh "https://官方文档URL"
```

#### 第 2 层: 查找现成技能
```bash
# 使用 Vercel Skills CLI 搜索公共技能库
npx skills find "debugging docker"
npx skills add vercel-labs/agent-skills --skill docker-debug
```

#### 第 3 层: 自主创建技能
```bash
# Agent 可以创建新的诊断脚本
cat > skills/new-diagnostic.sh << 'SCRIPT'
#!/bin/bash
# 自动生成的新技能
echo "执行诊断..."
SCRIPT
chmod +x skills/new-diagnostic.sh
```

---

## 📦 新增工具清单

### 1. analyze-image.sh - 图像分析
```bash
# 分析截图中的错误信息
bash skills/analyze-image.sh /path/to/screenshot.png

# 功能:
# - Tesseract OCR 提取中英文文本
# - （可选）Ollama LLaVA 理解图片内容
```

### 2. search-web.sh - 网页搜索
```bash
# 搜索技术问题解决方案
bash skills/search-web.sh "openclaw gateway not starting"

# 特点:
# - 使用 DuckDuckGo（无需 API Key）
# - 自动格式化输出
```

### 3. crawl-page.sh - 网页抓取
```bash
# 获取官方文档内容
bash skills/crawl-page.sh "https://docs.openclaw.ai/troubleshooting"

# 优势:
# - 转换为纯文本，易于 LLM 理解
# - 支持 wget + html2text 或 lynx
```

### 4. remote-diagnose.sh - 远程诊断
```bash
# SSH 连接并诊断远程服务器
bash skills/remote-diagnose.sh 192.168.1.100 admin 22

# 能力:
# - 自动化远程系统检查
# - 收集日志、配置、进程信息
```

---

## 🚀 升级前后对比

### 架构演进
```
【升级前】
用户问题 → Agent → 固定技能库 → 执行 → 回复
                      ↓（失败）
                   "无法处理"

【升级后】
用户问题 → Agent
            ↓
    检查本地技能库
            ↓（没有）
    搜索网页解决方案 ← 免费 DuckDuckGo
            ↓
    查找公共技能库 ← Vercel Skills
            ↓
    自主创建新技能 ← Qwen3-Coder-Plus
            ↓
    执行 → 记录学习 → 回复
```

### 能力矩阵
| 能力 | 升级前 | 升级后 |
|------|--------|--------|
| 本地系统诊断 | ✅ 完整 | ✅ 完整 |
| 日志分析 | ✅ 完整 | ✅ 完整 |
| 配置检查 | ✅ 完整 | ✅ 完整 |
| **图像分析** | ❌ 依赖 GSK | ✅ Tesseract + Ollama |
| **网页搜索** | ❌ 依赖 GSK | ✅ DuckDuckGo |
| **网页抓取** | ❌ 依赖 GSK | ✅ wget + html2text |
| **远程诊断** | ⚠️ 手动 | ✅ 自动化脚本 |
| **自主学习** | ❌ 无 | ✅ 三层机制 |
| **成本** | ⚠️ 可能付费 | ✅ 100% 免费 |

---

## 🛠️ 安装可选依赖

### 最小配置（仅系统工具）
```bash
sudo apt-get install -y tesseract-ocr tesseract-ocr-chi-sim lynx html2text
```

### 推荐配置（增加本地 AI）
```bash
# 安装 Ollama（本地 LLM 引擎）
curl -fsSL https://ollama.com/install.sh | sh

# 下载模型
ollama pull llava:7b      # 图像理解（4.7GB）
ollama pull qwen2:7b      # 文本处理（4.4GB）

# 安装 Skills CLI（技能管理）
npm install -g @vercel/skills
```

---

## 📝 使用示例

### 示例 1: 诊断服务启动失败
```bash
# 用户: "我的 OpenClaw Gateway 启动不了"

# Agent 自动执行:
bash skills/service-check.sh openclaw-gateway --user
journalctl --user -u openclaw-gateway -n 50
bash skills/search-web.sh "openclaw gateway failed to start"

# 找到解决方案后执行修复并验证
```

### 示例 2: 分析用户发送的错误截图
```bash
# 用户: [发送截图]

# Agent 自动执行:
bash skills/analyze-image.sh /tmp/user_screenshot.png
# 输出: "Error: EADDRINUSE: address already in use :::18789"

bash skills/port-check.sh 18789
# 输出: "端口 18789 被 PID 12345 (node) 占用"

# 提供解决方案: kill 12345 && systemctl --user restart openclaw-gateway
```

### 示例 3: 学习新技能
```bash
# 用户: "帮我诊断 Docker 容器问题"

# Agent 发现没有 Docker 诊断技能:
npx skills find "docker debugging"
# 找到: vercel-labs/agent-skills/docker-health-check

npx skills add vercel-labs/agent-skills --skill docker-health-check
# 安装到 ~/.openclaw/workspace/agents/debugger/skills/

# 下次遇到 Docker 问题时直接调用新技能
```

---

## ✅ 验证安装

### 测试所有工具
```bash
cd ~/.openclaw/workspace/agents/debugger

# 1. 测试图像分析（需要一张截图）
# bash skills/analyze-image.sh test.png

# 2. 测试网页搜索
bash skills/search-web.sh "openclaw documentation"

# 3. 测试网页抓取
bash skills/crawl-page.sh "https://docs.openclaw.ai"

# 4. 测试远程诊断（需要远程服务器）
# bash skills/remote-diagnose.sh 192.168.1.100 user

# 5. 测试本地诊断
bash skills/health-check.sh
bash skills/service-check.sh openclaw-gateway --user
```

---

## 📚 相关文档

- `README.md` - Agent 总体介绍
- `QUICK_START.md` - 快速上手指南
- `ADVANCED_USAGE.md` - 高级配置
- `system-prompt-v2.md` - 最新系统提示词（开源版）
- `OPEN_ALTERNATIVES.md` - 开源替代方案详解
- `诊断群配置成功.md` - 飞书群路由配置

---

## 🎉 总结

**核心成就**:
1. ✅ 移除所有付费依赖（GSK CLI）
2. ✅ 实现 100% 开源工具链
3. ✅ 增加自主学习能力
4. ✅ 保持零成本运行
5. ✅ 能力不减反增

**成本对比**:
- 升级前: 可能产生 GSK API 调用费用
- 升级后: **完全免费**，仅消耗本地算力

**下一步**:
1. 重启 OpenClaw Gateway 激活新配置
2. 在飞书诊断群测试新功能
3. 逐步安装可选依赖（Ollama、Skills CLI）
4. 随着使用不断学习新技能

---

**最后更新**: 2026-03-13  
**版本**: v2.0 (Open Source Edition)
