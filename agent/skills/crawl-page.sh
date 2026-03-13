#!/bin/bash
# 免费网页抓取工具

URL="$1"

if [[ -z "$URL" ]]; then
  echo "用法: $0 <网页 URL>"
  exit 1
fi

echo "📄 抓取网页: $URL"
echo ""

# 检查工具
if ! command -v html2text &>/dev/null; then
  echo "正在安装 html2text..."
  sudo apt-get install -y html2text 2>/dev/null
fi

# 方法 1: wget + html2text（推荐）
if command -v html2text &>/dev/null; then
  wget -q -O - "$URL" 2>/dev/null | html2text -width 100
  exit 0
fi

# 方法 2: lynx 浏览器
if command -v lynx &>/dev/null; then
  lynx -dump -nolist "$URL" 2>/dev/null
  exit 0
fi

# 方法 3: curl 原始 HTML
echo "⚠️  未找到文本转换工具，输出原始 HTML："
curl -s "$URL"
