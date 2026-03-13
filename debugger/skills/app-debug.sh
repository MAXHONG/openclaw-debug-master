#!/bin/bash
# 应用程序启动诊断助手

APP_CMD="$1"

if [[ -z "$APP_CMD" ]]; then
    echo "Usage: $0 <command-to-run>"
    echo "Example: $0 'node index.js'"
    exit 1
fi

echo "=== Application Debug Report ==="
echo "Command: $APP_CMD"
echo ""

# 1. 检查命令是否存在
echo "### 1. Command Availability"
CMD_NAME=$(echo "$APP_CMD" | awk '{print $1}')
which "$CMD_NAME" && echo "✅ Command found" || echo "❌ Command not found in PATH"
echo ""

# 2. 尝试运行并捕获输出
echo "### 2. Execution Test"
echo "Running: $APP_CMD"
echo "--- Output Start ---"
timeout 5 bash -c "$APP_CMD" 2>&1 || echo "(Command timed out or failed)"
echo "--- Output End ---"
echo ""

# 3. 检查常见问题
echo "### 3. Common Issues Check"

# 检查是否是 Node.js 应用
if [[ "$APP_CMD" == *"node"* ]]; then
    echo "Node.js version:"
    node --version
    echo "Checking for package.json..."
    [[ -f package.json ]] && echo "✅ package.json found" || echo "❌ package.json NOT found"
    echo "Checking node_modules..."
    [[ -d node_modules ]] && echo "✅ node_modules exists" || echo "❌ node_modules NOT found (run npm install)"
fi

# 检查是否是 Python 应用
if [[ "$APP_CMD" == *"python"* ]]; then
    echo "Python version:"
    python3 --version
    echo "Checking for requirements.txt..."
    [[ -f requirements.txt ]] && echo "✅ requirements.txt found" || echo "❌ requirements.txt NOT found"
fi

echo ""
echo "=== End of Debug Report ==="
