#!/bin/bash
# 快速检查服务状态的诊断脚本
# 用法: ./service-check.sh <service-name> [--user]

SERVICE="$1"
USER_MODE=""

if [[ "$2" == "--user" ]]; then
    USER_MODE="--user"
fi

echo "=== Service Diagnostic Report ==="
echo "Service: $SERVICE"
echo "Mode: ${USER_MODE:-system}"
echo ""

# 1. 服务状态
echo "### 1. Service Status"
if [[ -n "$USER_MODE" ]]; then
    systemctl --user status "$SERVICE" --no-pager | head -20
else
    systemctl status "$SERVICE" --no-pager | head -20
fi
echo ""

# 2. 最近日志（最后 30 行）
echo "### 2. Recent Logs (last 30 lines)"
if [[ -n "$USER_MODE" ]]; then
    journalctl --user -u "$SERVICE" -n 30 --no-pager
else
    journalctl -u "$SERVICE" -n 30 --no-pager
fi
echo ""

# 3. 错误日志（最近 100 行中的错误）
echo "### 3. Error Messages"
if [[ -n "$USER_MODE" ]]; then
    journalctl --user -u "$SERVICE" -n 100 --no-pager | grep -i "error\|fail\|fatal\|exception" | tail -10
else
    journalctl -u "$SERVICE" -n 100 --no-pager | grep -i "error\|fail\|fatal\|exception" | tail -10
fi
echo ""

# 4. 端口监听（如果服务应该监听端口）
echo "### 4. Port Listening"
sudo netstat -tlnp | grep "$SERVICE" || echo "No ports found for this service"
echo ""

echo "=== End of Report ==="
