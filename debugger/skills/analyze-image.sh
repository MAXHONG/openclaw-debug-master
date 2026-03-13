#!/bin/bash
# 开源图像分析工具（完全免费）

IMAGE_PATH="$1"

if [[ -z "$IMAGE_PATH" ]]; then
  echo "用法: $0 <图片路径>"
  exit 1
fi

if [[ ! -f "$IMAGE_PATH" ]]; then
  echo "❌ 错误: 图片不存在 $IMAGE_PATH"
  exit 1
fi

echo "📸 分析图片: $IMAGE_PATH"
echo ""

# 1. Tesseract OCR 提取文本
if command -v tesseract &>/dev/null; then
  echo "=== OCR 文本提取 ==="
  tesseract "$IMAGE_PATH" - -l chi_sim+eng 2>/dev/null || echo "（OCR 未检测到文本）"
  echo ""
else
  echo "⚠️  Tesseract 未安装，跳过 OCR"
  echo "   安装命令: sudo apt-get install tesseract-ocr tesseract-ocr-chi-sim"
  echo ""
fi

# 2. 如果安装了 Ollama，使用 LLaVA 分析
if command -v ollama &>/dev/null; then
  if ollama list | grep -q llava; then
    echo "=== AI 图像理解 (LLaVA) ==="
    ollama run llava:7b "请用中文描述这张图片中的错误信息、界面状态或技术问题。如果是终端或代码截图，请提取关键错误内容。" < "$IMAGE_PATH" 2>/dev/null
  else
    echo "💡 安装 LLaVA 可获得更智能的图像理解："
    echo "   ollama pull llava:7b"
  fi
else
  echo "💡 安装 Ollama + LLaVA 可获得 AI 图像理解："
  echo "   curl -fsSL https://ollama.com/install.sh | sh"
  echo "   ollama pull llava:7b"
fi
