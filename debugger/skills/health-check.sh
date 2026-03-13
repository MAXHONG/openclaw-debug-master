#!/bin/bash
# 系统整体健康检查

echo "=== System Health Check ==="
echo "Timestamp: $(date)"
echo ""

# 1. CPU & Memory
echo "### 1. CPU & Memory"
echo "Load Average:"
uptime
echo ""
echo "Memory Usage:"
free -h
echo ""
echo "Top CPU Processes:"
ps aux --sort=-%cpu | head -6
echo ""

# 2. Disk Usage
echo "### 2. Disk Usage"
df -h | grep -E '^/dev|Filesystem'
echo ""

# 3. Network
echo "### 3. Network Status"
echo "Listening Ports:"
sudo netstat -tlnp | head -10
echo ""

# 4. Recent System Errors
echo "### 4. Recent System Errors"
journalctl -p err -n 10 --no-pager
echo ""

# 5. Failed Services
echo "### 5. Failed Services"
systemctl list-units --state=failed --no-pager
systemctl --user list-units --state=failed --no-pager 2>/dev/null
echo ""

echo "=== End of Health Check ==="
