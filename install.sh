#!/bin/bash
# OpenClaw Debug Master Agent - One-Click Installer
# Version: 2.0.0
# License: MIT

set -e

echo "================================================"
echo "  OpenClaw Debug Master Agent Installer"
echo "  Version: 2.0.0"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if OpenClaw is installed
if ! command -v openclaw &> /dev/null; then
    echo -e "${RED}❌ OpenClaw is not installed!${NC}"
    echo "Please install OpenClaw first: https://docs.openclaw.ai/installation"
    exit 1
fi

echo -e "${GREEN}✅ OpenClaw found${NC}"

# Check OpenClaw version
OPENCLAW_VERSION=$(openclaw --version 2>&1 | grep -oP '\d+\.\d+\.\d+' | head -1)
echo "OpenClaw version: $OPENCLAW_VERSION"

# Create agent workspace
AGENT_DIR="$HOME/.openclaw/workspace/agents/debugger"
echo ""
echo "📁 Creating agent workspace at $AGENT_DIR"

if [ -d "$AGENT_DIR" ]; then
    echo -e "${YELLOW}⚠️  Agent directory already exists${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Backing up existing agent..."
    mv "$AGENT_DIR" "$AGENT_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

mkdir -p "$AGENT_DIR"
mkdir -p "$AGENT_DIR/skills"

# Download or copy files
echo ""
echo "📦 Installing Debug Master Agent files..."

# If running from cloned repo
if [ -f "$(dirname "$0")/agent/AGENTS.md" ]; then
    echo "Copying from local files..."
    cp -r "$(dirname "$0")"/agent/* "$AGENT_DIR/"
else
    echo "Downloading from GitHub..."
    REPO_URL="https://raw.githubusercontent.com/MAXHONG/openclaw-debug-master/main"
    
    # Download files
    curl -fsSL "$REPO_URL/agent/AGENTS.md" -o "$AGENT_DIR/AGENTS.md"
    curl -fsSL "$REPO_URL/agent/agent.json" -o "$AGENT_DIR/agent.json"
    curl -fsSL "$REPO_URL/agent/README.md" -o "$AGENT_DIR/README.md"
    curl -fsSL "$REPO_URL/agent/QUICK_START.md" -o "$AGENT_DIR/QUICK_START.md"
    
    # Download skills
    for skill in service-check health-check port-check app-debug analyze-image search-web crawl-page remote-diagnose; do
        curl -fsSL "$REPO_URL/agent/skills/${skill}.sh" -o "$AGENT_DIR/skills/${skill}.sh"
        chmod +x "$AGENT_DIR/skills/${skill}.sh"
    done
fi

echo -e "${GREEN}✅ Files installed${NC}"

# Install system dependencies
echo ""
echo "📦 Installing system dependencies..."

if command -v apt-get &> /dev/null; then
    echo "Detected Debian/Ubuntu, installing via apt-get..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq tesseract-ocr tesseract-ocr-chi-sim lynx html2text
elif command -v yum &> /dev/null; then
    echo "Detected RHEL/CentOS, installing via yum..."
    sudo yum install -y tesseract lynx html2text
else
    echo -e "${YELLOW}⚠️  Could not detect package manager, skipping system dependencies${NC}"
    echo "Please manually install: tesseract-ocr, lynx, html2text"
fi

echo -e "${GREEN}✅ Dependencies installed${NC}"

# Configure agent in OpenClaw
echo ""
echo "⚙️  Configuring Debug Master Agent..."

# Check if agent already exists
if openclaw agents list 2>&1 | grep -q "debugger"; then
    echo -e "${YELLOW}⚠️  Debugger agent already exists${NC}"
else
    # Add agent to config
    AGENT_CONFIG='{
  "id": "debugger",
  "identity": {
    "name": "Debug Master"
  },
  "workspace": "'$AGENT_DIR'",
  "model": {
    "primary": "aliyun/qwen3-coder-plus",
    "fallbacks": [
      "minimax/MiniMax-M2.5-highspeed",
      "tencent/hunyuan-2.0-thinking",
      "aliyun/qwen3.5-plus"
    ]
  }
}'

    # Add to agents.list
    openclaw config set agents.list[+] "$AGENT_CONFIG" --json
    echo -e "${GREEN}✅ Agent configured${NC}"
fi

# Restart gateway
echo ""
echo "🔄 Restarting OpenClaw Gateway..."
systemctl --user restart openclaw-gateway
sleep 5

# Verify installation
echo ""
echo "🧪 Verifying installation..."

if openclaw agents list 2>&1 | grep -q "debugger"; then
    echo -e "${GREEN}✅ Debug Master Agent installed successfully!${NC}"
else
    echo -e "${RED}❌ Installation verification failed${NC}"
    exit 1
fi

# Show usage
echo ""
echo "================================================"
echo "  Installation Complete!"
echo "================================================"
echo ""
echo "📖 Quick Start:"
echo ""
echo "  1. Test the agent:"
echo "     openclaw chat --agent debugger --message \"Check system health\""
echo ""
echo "  2. Switch to debugger in chat:"
echo "     /agent debugger"
echo ""
echo "  3. View documentation:"
echo "     cat $AGENT_DIR/README.md"
echo ""
echo "  4. Run diagnostic skills directly:"
echo "     bash $AGENT_DIR/skills/health-check.sh"
echo ""
echo "📚 Full Documentation: https://github.com/MAXHONG/openclaw-debug-master"
echo ""
echo "🎉 Enjoy troubleshooting with Debug Master!"
echo ""
