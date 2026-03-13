# OpenClaw Debug Master Agent

[English](./README.md) | 中文

## 简介

OpenClaw Debug Master Agent 是一个专业的系统诊断和故障排查代理，专为 OpenClaw 框架设计。它可以帮助您快速诊断和解决各种系统问题。

## 功能特性

- 🔍 **服务状态检查** - 检查 OpenClaw Gateway、Caddy、Nginx 等服务状态
- 💓 **系统健康监控** - 监控系统资源使用情况
- 🔌 **端口冲突诊断** - 检测并解决端口占用问题
- 🖥️ **远程 SSH 诊断** - 通过 SSH 进行远程服务器诊断
- 🖼️ **图像错误分析** - 使用 OCR 分析错误截图
- 🌐 **Web 搜索解决方案** - 自动搜索问题解决方案
- 📝 **日志分析** - 分析系统日志找出问题根源

## 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/MAXHONG/openclaw-debug-master.git
cd openclaw-debug-master

# 运行安装脚本
chmod +x install.sh
./install.sh
```

### 使用方法

在 OpenClaw 中使用以下命令切换到 Debug Master：

```
/agent debugger
```

然后描述您遇到的问题，Debug Master 会自动帮您诊断。

## 诊断技能

Debug Master 配备以下诊断技能：

| 技能 | 功能 |
|------|------|
| `service-check.sh` | 检查系统服务状态 |
| `health-check.sh` | 执行系统健康检查 |
| `port-check.sh` | 检查端口占用情况 |
| `remote-diagnose.sh` | 远程 SSH 诊断 |
| `analyze-image.sh` | 分析错误截图 |
| `search-web.sh` | 搜索解决方案 |
| `app-debug.sh` | 应用调试 |
| `crawl-page.sh` | 抓取网页内容 |

## 配置

在 `agent/agent.json` 中配置 Agent：

```json
{
  "id": "debugger",
  "name": "Debug Master",
  "model": "qwen3-coder-plus",
  "workspace": "~/.openclaw/workspace/agents/debugger/"
}
```

## 文档

- [快速开始](./agent/QUICK_START.md) - 快速入门指南
- [高级用法](./agent/ADVANCED_USAGE.md) - 高级功能说明
- [升级说明](./agent/能力升级说明.md) - 功能升级记录

## 开源协议

MIT License

## 相关链接

- [OpenClaw 官网](https://github.com/openclaw/openclaw)
- [TTEAM 项目](https://github.com/MAXHONG/TTEAM) - AI Agent 管理平台

---

由 [Max Hong](https://github.com/MAXHONG) 开发和维护

## 模型配置

Debug Master 支持多种模型，您可以根据需要选择和配置。

### 配置方法

#### 方法一：通过 agent.json 配置

编辑 `agent/agent.json` 文件：

```json
{
  "id": "debugger",
  "name": "Debug Master",
  "model": {
    "primary": "qwen3-coder-plus",
    "fallbacks": [
      "minimax/MiniMax-M2.5-highspeed",
      "tencent/hunyuan-2.0-thinking"
    ]
  }
}
```

#### 方法二：通过 OpenClaw 命令行配置

```bash
# 查看可用模型
openclaw models list

# 设置 Debug Master 使用的模型
openclaw agents set-model debugger --model qwen3-coder-plus
```

### 推荐模型

| 模型 | 特点 | 适用场景 |
|------|------|----------|
| `qwen3-coder-plus` | 编程能力强，性价比高 | ✅ 推荐 |
| `minimax/MiniMax-M2.5-highspeed` | 速度快，便宜 | 简单诊断 |
| `anthropic/claude-sonnet-4-20250514` | 能力强 | 复杂问题 |
| `tencent/hunyuan-2.0-thinking` | 国产模型 | 国内用户 |

### 环境变量配置

如果使用第三方模型 API，需要设置环境变量：

```bash
# OpenAI 格式 API
export OPENAI_API_KEY="your-api-key"
export OPENAI_BASE_URL="https://api.openai.com/v1"

# Azure OpenAI
export AZURE_OPENAI_API_KEY="your-key"
export AZURE_OPENAI_ENDPOINT="https://your-resource.openai.azure.com/"

# Anthropic
export ANTHROPIC_API_KEY="your-key"
```

### 验证配置

配置完成后，运行测试验证：

```bash
cd ~/.openclaw/workspace/agents/debugger
bash test-debugger.sh
```

如果测试通过，说明模型配置成功！
