#!/bin/bash
# 检查端口使用情况
# 用法: ./port-check.sh <port>

PORT="$1"

if [[ -z "$PORT" ]]; then
    echo "Usage: $0 <port>"
    exit 1
fi

echo "=== Port $PORT Diagnostic ==="
echo ""

# 1. 谁在监听这个端口
echo "### 1. Process Listening on Port $PORT"
sudo lsof -i ":$PORT" -P -n 2>/dev/null || echo "No process listening on port $PORT"
echo ""

# 2. TCP 连接状态
echo "### 2. TCP Connections"
sudo netstat -anp | grep ":$PORT " | head -10 || echo "No connections on port $PORT"
echo ""

# 3. 防火墙规则
echo "### 3. Firewall Check"
if command -v ufw &> /dev/null; then
    sudo ufw status | grep "$PORT" || echo "No UFW rules for port $PORT"
else
    echo "UFW not installed"
fi
echo ""

# 4. 尝试本地连接
echo "### 4. Local Connectivity Test"
timeout 2 bash -c "echo > /dev/tcp/127.0.0.1/$PORT" 2>/dev/null && \
    echo "✅ Port $PORT is reachable locally" || \
    echo "❌ Port $PORT is NOT reachable locally"
echo ""

echo "=== End of Port Diagnostic ==="
