#!/bin/bash
# 免费网页搜索工具

QUERY="$*"

if [[ -z "$QUERY" ]]; then
  echo "用法: $0 <搜索关键词>"
  exit 1
fi

echo "🔍 搜索: $QUERY"
echo ""

# 检查 lynx 是否安装
if ! command -v lynx &>/dev/null; then
  echo "❌ lynx 未安装，正在安装..."
  sudo apt-get install -y lynx 2>/dev/null
fi

# 使用 DuckDuckGo（完全免费，无 API Key）
ENCODED_QUERY=$(echo "$QUERY" | sed 's/ /+/g')
curl -s "https://html.duckduckgo.com/html/?q=${ENCODED_QUERY}" | \
  lynx -dump -stdin 2>/dev/null | \
  grep -E "^[[:space:]]*[0-9]+\.|http" | \
  head -30

echo ""
echo "💡 获取更多结果: https://duckduckgo.com/?q=${ENCODED_QUERY}"
