# 开源替代方案配置指南

## 问题背景
GSK CLI 是 Genspark 的私有服务，需要 API Key 且可能产生费用。
为确保 Debug Master Agent 完全免费且自主可控，我们提供以下开源替代方案。

## 核心能力替代方案

### 1. 图像分析能力（替代 gsk analyze）

#### 方案 A: Tesseract OCR（文本提取）
```bash
# 安装
sudo apt-get install tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-chi-tra

# 使用
tesseract screenshot.png output -l chi_sim+eng
cat output.txt
```

#### 方案 B: PaddleOCR（中文支持更好）
```bash
# 安装
pip3 install paddlepaddle paddleocr

# 使用
paddleocr --image_dir screenshot.png --lang ch
```

#### 方案 C: Ollama + LLaVA（理解图片内容）
```bash
# 安装 Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 下载 LLaVA 模型（7B 小模型）
ollama pull llava:7b

# 使用（理解截图错误）
ollama run llava:7b "分析这张截图中的错误信息" < screenshot.png
```

### 2. 网页搜索能力（替代 gsk search）

#### 方案 A: SearXNG（自托管搜索引擎）
```bash
# Docker 部署
docker run -d --name searxng \
  -p 8080:8080 \
  -v $(pwd)/searxng:/etc/searxng \
  searxng/searxng:latest

# 使用
curl "http://localhost:8080/search?q=openclaw+error&format=json"
```

#### 方案 B: DuckDuckGo API（免费）
```bash
# 简单搜索脚本
search_web() {
  local query="$1"
  curl -s "https://html.duckduckgo.com/html/?q=${query}" | \
    lynx -dump -stdin | head -30
}

search_web "openclaw gateway not starting"
```

### 3. 网页抓取能力（替代 gsk crawl）

#### 方案 A: wget + html2text
```bash
# 安装
sudo apt-get install html2text

# 使用
wget -q -O - "https://docs.openclaw.ai/troubleshooting" | \
  html2text -width 80
```

#### 方案 B: Lynx 浏览器
```bash
# 安装
sudo apt-get install lynx

# 使用
lynx -dump -nolist "https://docs.openclaw.ai/troubleshooting"
```

### 4. 文档摘要能力（替代 gsk summarize）

#### 方案: 本地 LLM（Ollama + Qwen）
```bash
# 下载轻量模型
ollama pull qwen2:7b

# 摘要文档
cat long_document.txt | ollama run qwen2:7b "请总结以下内容的关键要点："
```

## 集成到 Debug Master Agent

### 步骤 1: 安装基础工具
```bash
# OCR 工具
sudo apt-get install -y tesseract-ocr tesseract-ocr-chi-sim

# 文本处理
sudo apt-get install -y html2text lynx

# Python OCR（可选）
pip3 install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 步骤 2: 创建统一工具脚本
```bash
cat > ~/.openclaw/workspace/agents/debugger/skills/analyze-image.sh << 'SCRIPT'
#!/bin/bash
# 开源图像分析工具

IMAGE_PATH="$1"

if [[ ! -f "$IMAGE_PATH" ]]; then
  echo "错误: 图片不存在 $IMAGE_PATH"
  exit 1
fi

echo "=== 使用 Tesseract OCR 提取文本 ==="
tesseract "$IMAGE_PATH" - -l chi_sim+eng 2>/dev/null || echo "OCR 失败"

# 如果安装了 Ollama，使用 LLaVA 分析
if command -v ollama &>/dev/null; then
  echo ""
  echo "=== 使用 LLaVA 分析图片内容 ==="
  ollama run llava:7b "这张图片显示了什么错误或问题？请用中文描述。" < "$IMAGE_PATH"
fi
SCRIPT

chmod +x ~/.openclaw/workspace/agents/debugger/skills/analyze-image.sh
```

### 步骤 3: 创建搜索脚本
```bash
cat > ~/.openclaw/workspace/agents/debugger/skills/search-web.sh << 'SCRIPT'
#!/bin/bash
# 免费网页搜索

QUERY="$*"

echo "=== 搜索结果: $QUERY ==="
curl -s "https://html.duckduckgo.com/html/?q=${QUERY}" | \
  lynx -dump -stdin | \
  grep -A 3 "http" | \
  head -50
SCRIPT

chmod +x ~/.openclaw/workspace/agents/debugger/skills/search-web.sh
```

## 更新系统提示词

在 `system-prompt.md` 中移除 GSK 依赖：

```markdown
### 可用工具（完全免费）

1. **图像分析**
   - OCR 文本提取: `bash skills/analyze-image.sh screenshot.png`
   - 识别中英文错误信息

2. **网页搜索**
   - `bash skills/search-web.sh "openclaw error message"`

3. **文档获取**
   - `wget -q -O - URL | html2text`

4. **本地诊断**
   - Shell 命令、日志分析、配置检查
```

## 成本对比

| 功能 | GSK 方案 | 开源方案 | 成本 |
|------|---------|----------|------|
| 图像 OCR | gsk analyze | Tesseract/PaddleOCR | **免费** |
| 图像理解 | gsk analyze | Ollama LLaVA | **免费** |
| 网页搜索 | gsk search | DuckDuckGo/SearXNG | **免费** |
| 网页抓取 | gsk crawl | wget/lynx | **免费** |
| 文档摘要 | gsk summarize | Ollama Qwen | **免费** |
| 远程诊断 | SSH（已有） | SSH（已有） | **免费** |

## 推荐配置（平衡性能和资源）

```bash
# 最小配置（仅依赖系统工具）
sudo apt-get install tesseract-ocr lynx html2text

# 推荐配置（增加本地 AI）
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llava:7b      # 图像理解（4.7GB）
ollama pull qwen2:7b      # 文本处理（4.4GB）
```

## 自动技能发现（回答您的第二个问题）

### 概念: Agent 自主学习新技能

```bash
# 安装 Vercel Skills CLI
npm install -g @vercel/skills

# Agent 可以自动安装技能
npx skills add vercel-labs/agent-skills  # 公共技能库
npx skills find "docker debugging"        # 搜索技能
npx skills add https://github.com/xxx/custom-skill  # 安装自定义技能
```

### 集成到 Debug Master

在 `system-prompt.md` 添加自我学习机制：

```markdown
## 自主学习能力

当遇到陌生问题时：

1. **搜索解决方案**
   ```bash
   bash skills/search-web.sh "how to diagnose [问题描述]"
   ```

2. **查找相关技能**
   ```bash
   npx skills find "debugging [技术栈]"
   ```

3. **自动安装验证过的技能**
   ```bash
   # 从可信来源安装
   npx skills add vercel-labs/agent-skills --skill docker-debug
   npx skills add github.com/openclaw/community-skills
   ```

4. **验证技能安全性**
   - 检查技能来源（GitHub stars、维护者）
   - 阅读 `SKILL.md` 确认行为
   - 在沙箱中测试
   - 记录到 `~/.openclaw/workspace/agents/debugger/learned-skills.md`

5. **持续优化**
   - 记录每次诊断过程
   - 识别重复性问题
   - 创建新的技能脚本
```

## 实现真正的"智能 Agent"

### 当前架构
```
用户问题 → Debug Master → 固定技能库 → 执行 → 回复
                ↓（如果失败）
              报告"无法处理"
```

### 升级架构（智能学习）
```
用户问题 → Debug Master
            ↓
    检查已有技能
            ↓（没有）
    搜索解决方案 + 查找技能
            ↓
    评估安全性 → 安装技能
            ↓
    执行 → 记录学习 → 回复
```

### 实现示例脚本

```bash
cat > ~/.openclaw/workspace/agents/debugger/skills/smart-diagnose.sh << 'SCRIPT'
#!/bin/bash
# 智能诊断：自动学习新技能

PROBLEM="$1"
SKILL_NAME=$(echo "$PROBLEM" | tr ' ' '-')

echo "🔍 分析问题: $PROBLEM"

# 1. 检查是否已有相关技能
if ls skills/*"$SKILL_NAME"* 2>/dev/null; then
  echo "✅ 找到已有技能，直接执行"
  bash skills/*"$SKILL_NAME"*
  exit 0
fi

# 2. 搜索解决方案
echo "🌐 搜索解决方案..."
SOLUTION=$(bash skills/search-web.sh "$PROBLEM troubleshooting" | head -20)

echo "$SOLUTION"

# 3. 查找相关技能
echo "📦 搜索可用技能..."
npx skills find "$PROBLEM" 2>/dev/null || echo "未找到预制技能"

# 4. 询问用户是否安装新技能
echo ""
echo "❓ 是否需要我学习处理这类问题的新技能？(y/n)"
read -r ANSWER

if [[ "$ANSWER" == "y" ]]; then
  echo "📚 正在学习..."
  # 这里可以接入 LLM 生成技能脚本
  echo "技能生成功能开发中..."
fi
SCRIPT

chmod +x ~/.openclaw/workspace/agents/debugger/skills/smart-diagnose.sh
```

