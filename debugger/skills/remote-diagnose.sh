#!/bin/bash
# 远程服务器快速诊断脚本
# 用法: ./remote-diagnose.sh user@host [port]

if [[ $# -lt 1 ]]; then
    echo "用法: $0 user@host [port]"
    echo "示例: $0 root@192.168.1.100"
    echo "示例: $0 admin@example.com 2222"
    exit 1
fi

TARGET="$1"
PORT="${2:-22}"

echo "=== 远程服务器诊断 ==="
echo "目标: $TARGET"
echo "端口: $PORT"
echo ""

# 测试连接
echo "### 1. 测试连接"
if ssh -p "$PORT" -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$TARGET" "echo 'OK'" 2>/dev/null; then
    echo "✅ 连接成功"
else
    echo "❌ 连接失败"
    echo "请检查："
    echo "  - 服务器地址是否正确"
    echo "  - SSH 端口是否正确"
    echo "  - 网络是否通畅"
    echo "  - 认证密钥是否配置"
    exit 1
fi
echo ""

# 执行远程诊断
echo "### 2. 系统信息"
ssh -p "$PORT" "$TARGET" << 'EOF'
echo "主机名: $(hostname)"
echo "系统: $(uname -s)"
echo "内核: $(uname -r)"
echo "架构: $(uname -m)"
echo "运行时间:"
uptime
EOF
echo ""

echo "### 3. 资源使用"
ssh -p "$PORT" "$TARGET" << 'EOF'
echo "--- CPU 负载 ---"
uptime | awk -F'load average:' '{print $2}'

echo ""
echo "--- 内存使用 ---"
free -h | grep -E "^Mem:|^Swap:"

echo ""
echo "--- 磁盘空间 ---"
df -h | grep -E "^/dev|^Filesystem"
EOF
echo ""

echo "### 4. 失败的服务"
ssh -p "$PORT" "$TARGET" "systemctl list-units --failed --no-pager 2>/dev/null || echo 'systemd 不可用或无权限'"
echo ""

echo "### 5. 网络监听"
ssh -p "$PORT" "$TARGET" "ss -tlnp 2>/dev/null | head -10 || netstat -tlnp 2>/dev/null | head -10 || echo '需要 root 权限查看进程'"
echo ""

echo "### 6. 最近的系统错误"
ssh -p "$PORT" "$TARGET" "journalctl -p err -n 5 --no-pager 2>/dev/null || tail -20 /var/log/syslog 2>/dev/null || echo '无法读取日志'"
echo ""

echo "=== 诊断完成 ==="
