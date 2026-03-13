[English] | [中文](README_CN.md)

# OpenClaw Debug Master Agent

<div align="center">

![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![OpenClaw](https://img.shields.io/badge/openclaw-%3E%3D2026.3-orange.svg)

**A professional system diagnosis and troubleshooting agent for OpenClaw**

[Features](#-features) • [Quick Start](#-quick-start) • [Installation](#-installation) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 🎯 What is Debug Master?

Debug Master is a specialized OpenClaw agent designed for **system diagnosis, troubleshooting, and debugging**. Unlike general-purpose agents, Debug Master is optimized for:

- ✅ **System service diagnostics** (systemd, Docker, Nginx, etc.)
- ✅ **Log analysis and error tracking**
- ✅ **Port conflict detection**
- ✅ **Remote server diagnostics via SSH**
- ✅ **OCR-based error screenshot analysis**
- ✅ **Automatic web search for solutions**
- ✅ **Self-learning new diagnostic skills**

### 🆚 Main Agent vs Debug Master

| Task | Main Agent | Debug Master |
|------|------------|--------------|
| General conversation | ✅ Expert | ❌ |
| Code generation | ✅ Expert | ❌ |
| Web scraping | ✅ Expert | ❌ |
| **Service diagnosis** | ⚠️ Basic | ✅ **Expert** |
| **Log analysis** | ⚠️ Basic | ✅ **Expert** |
| **System troubleshooting** | ⚠️ Basic | ✅ **Expert** |
| **OCR error analysis** | ❌ | ✅ **Expert** |
| **Auto-search solutions** | ❌ | ✅ **Expert** |

---

## ✨ Features

### 🛠️ Core Diagnostic Skills

1. **Service Status Check** - `service-check.sh`
   - Systemd service status (user/system)
   - Process monitoring
   - Auto-restart suggestions

2. **System Health Check** - `health-check.sh`
   - CPU, memory, disk usage
   - Load average
   - Top processes

3. **Port Conflict Detection** - `port-check.sh`
   - Find which process occupies a port
   - Kill process guidance
   - Alternative port suggestions

4. **Application Debugging** - `app-debug.sh`
   - Process tree inspection
   - Environment variables
   - Open files and connections

5. **Image Error Analysis** - `analyze-image.sh`
   - Tesseract OCR text extraction
   - Ollama LLaVA AI image understanding (optional)
   - Error message parsing

6. **Web Search** - `search-web.sh`
   - DuckDuckGo free search (no API key)
   - Auto-format results
   - Find solutions online

7. **Web Crawling** - `crawl-page.sh`
   - wget + html2text
   - Extract documentation
   - Plain text output for LLM

8. **Remote Diagnostics** - `remote-diagnose.sh`
   - SSH automation
   - Remote system checks
   - Log collection

### 🧠 Three-Layer Self-Learning

1. **Layer 1: Search External Knowledge**
   - Auto-search DuckDuckGo for solutions
   - Crawl official documentation

2. **Layer 2: Install Public Skills**
   - Use Vercel Skills CLI
   - Install from trusted sources (vercel-labs, openclaw community)
   - Safety verification before installation

3. **Layer 3: Create New Skills**
   - Generate diagnostic scripts with Qwen3-Coder-Plus
   - Record learning history
   - Continuous improvement

### 💰 100% Free & Open Source

All tools are **completely free** and **open source**:

| Function | Proprietary Solution | Our Solution | Cost |
|----------|---------------------|--------------|------|
| Image OCR | Vision API (~$0.01/image) | Tesseract OCR | **$0** |
| Web Search | Search API (~$0.002/query) | DuckDuckGo | **$0** |
| Web Crawl | Crawling API (~$0.001/page) | wget + html2text | **$0** |
| LLM Model | Claude 3.5 Sonnet | Qwen3-Coder-Plus | **~70% cheaper** |
| **Total** | **Paid** | **Free** | **100% savings** |

---

## 🚀 Quick Start

### Prerequisites

- OpenClaw >= 2026.3
- Ubuntu 24.04 LTS (or similar Linux)
- Bash, Node.js 22+

### One-Command Installation

```bash
curl -fsSL https://raw.githubusercontent.com/MAXHONG/openclaw-debug-master/main/install.sh | bash
```

Or manual installation:

```bash
git clone https://github.com/MAXHONG/openclaw-debug-master.git
cd openclaw-debug-master
./install.sh
```

### What the Installer Does

1. Creates agent workspace at `~/.openclaw/workspace/agents/debugger/`
2. Copies 8 diagnostic skill scripts
3. Installs dependencies (Tesseract OCR, lynx, html2text)
4. Configures Debug Master agent in `~/.openclaw/openclaw.json`
5. Sets up intelligent routing (optional)
6. Restarts OpenClaw Gateway

### Post-Installation

**Test the agent**:

```bash
# Switch to Debug Master
openclaw chat --agent debugger

# Or check agent list
openclaw agents list --bindings
```

---

## 📖 Documentation

### Basic Usage

#### Method 1: Dedicated Diagnostic Channel (Recommended)

Configure a Feishu/Slack/Discord group to auto-route to Debug Master:

```bash
# Get group ID from logs
journalctl --user -u openclaw-gateway | grep "group:"

# Add routing rule
openclaw config set agents.routing[0] '{"agent":"debugger","channel":"feishu","peer":"group:YOUR_GROUP_ID"}' --json

# Restart gateway
systemctl --user restart openclaw-gateway
```

Now all messages in that group are handled by Debug Master automatically!

#### Method 2: Manual Switching

In your chat client:

```
/agent debugger
# Now in Debug Master mode

"Check system health"
# Debug Master responds with diagnostics

/agent main
# Switch back to main agent
```

#### Method 3: CLI

```bash
openclaw chat --agent debugger --message "Check if port 8080 is in use"
```

### Skill Reference

All skills are in `~/.openclaw/workspace/agents/debugger/skills/`:

```bash
# Check service status
bash skills/service-check.sh openclaw-gateway --user

# System health
bash skills/health-check.sh

# Port check
bash skills/port-check.sh 8080

# Analyze error screenshot
bash skills/analyze-image.sh /path/to/screenshot.png

# Search for solutions
bash skills/search-web.sh "openclaw gateway error"

# Crawl documentation
bash skills/crawl-page.sh "https://docs.openclaw.ai/troubleshooting"

# Remote diagnostics
bash skills/remote-diagnose.sh 192.168.1.100 admin 22
```

### Advanced Configuration

#### Enable AI Image Understanding (Optional)

Install Ollama + LLaVA for deeper image analysis:

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Download LLaVA model (4.7GB)
ollama pull llava:7b

# Now analyze-image.sh will use AI
bash skills/analyze-image.sh screenshot.png
```

#### Install Skills CLI (Optional)

Enable auto-discovery of community skills:

```bash
npm install -g @vercel/skills

# Search skills
npx skills find "docker debugging"

# Install skill
npx skills add vercel-labs/agent-skills --skill docker-debug
```

#### Change Model

Edit `~/.openclaw/workspace/agents/debugger/agent.json`:

```json
{
  "id": "debugger",
  "model": {
    "primary": "aliyun/qwen3-coder-plus",
    "fallbacks": [
      "minimax/MiniMax-M2.5-highspeed",
      "tencent/hunyuan-2.0-thinking"
    ]
  }
}
```

Restart gateway: `systemctl --user restart openclaw-gateway`

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│               OpenClaw Debug Master Agent                │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────┐       ┌──────────────────┐        │
│  │  System Prompt   │       │  8 Core Skills   │        │
│  │  (521 lines)     │       │  (Shell scripts) │        │
│  └────────┬─────────┘       └────────┬─────────┘        │
│           │                           │                  │
│           ├───────────────────────────┤                  │
│           │                           │                  │
│  ┌────────▼─────────┐       ┌────────▼─────────┐        │
│  │  Qwen3-Coder-    │       │  Open Source     │        │
│  │  Plus (LLM)      │◄──────┤  Tools           │        │
│  └──────────────────┘       │  - Tesseract     │        │
│                              │  - DuckDuckGo    │        │
│                              │  - wget/lynx     │        │
│                              │  - ssh           │        │
│                              └──────────────────┘        │
│                                                           │
│  ┌─────────────────────────────────────────────┐         │
│  │  Three-Layer Self-Learning                  │         │
│  │  1. Search knowledge (DuckDuckGo)           │         │
│  │  2. Install skills (Vercel Skills)          │         │
│  │  3. Create scripts (LLM generation)         │         │
│  └─────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 Testing

Run the test suite:

```bash
cd ~/.openclaw/workspace/agents/debugger
bash test-debugger.sh
```

Expected output:

```
✅ System health check: PASSED
✅ Service status check: PASSED
✅ Port check: PASSED
✅ Web search: PASSED
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-skill`)
3. Commit your changes (`git commit -m 'Add amazing diagnostic skill'`)
4. Push to the branch (`git push origin feature/amazing-skill`)
5. Open a Pull Request

### Adding New Skills

Create a new skill script in `skills/`:

```bash
cat > skills/my-diagnostic.sh << 'SCRIPT'
#!/bin/bash
# Description of what this skill does

# Your diagnostic logic here
echo "Diagnostic result..."
SCRIPT

chmod +x skills/my-diagnostic.sh
```

Update `AGENTS.md` to document the new skill.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [OpenClaw](https://github.com/openclaw/openclaw) - The underlying AI agent framework
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) - Open source OCR engine
- [Ollama](https://ollama.com/) - Local LLM runtime
- [Vercel Skills](https://github.com/vercel-labs/skills) - Agent skills framework

---

## 📞 Support

- **Documentation**: [Full Docs](./docs/)
- **Issues**: [GitHub Issues](https://github.com/MAXHONG/openclaw-debug-master/issues)
- **Discussions**: [GitHub Discussions](https://github.com/MAXHONG/openclaw-debug-master/discussions)

---

## 🌟 Star History

If you find this project useful, please consider giving it a ⭐!

---

<div align="center">

**Made with ❤️ by the OpenClaw Community**

[⬆ Back to Top](#openclaw-debug-master-agent)

</div>

## Model Configuration

Debug Master supports multiple models. Here's how to configure them:

### Configuration Methods

#### Method 1: Via agent.json

Edit `agent/agent.json`:

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

#### Method 2: Via OpenClaw CLI

```bash
# List available models
openclaw models list

# Set model for Debug Master
openclaw agents set-model debugger --model qwen3-coder-plus
```

### Recommended Models

| Model | Use Case |
|-------|----------|
| `qwen3-coder-plus` | ✅ Recommended - Best for coding/diagnostics |
| `minimax/MiniMax-M2.5-highspeed` | Fast, cheap |
| `anthropic/claude-sonnet-4-20250514` | Most capable |

### Environment Variables

```bash
export OPENAI_API_KEY="your-key"
export OPENAI_BASE_URL="https://api.openai.com/v1"
```

### Verify Configuration

```bash
cd ~/.openclaw/workspace/agents/debugger
bash test-debugger.sh
```
