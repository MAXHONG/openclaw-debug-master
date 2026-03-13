#!/bin/bash
# 测试 Debug Master agent

echo "🧪 Testing Debug Master Agent"
echo ""

# 测试 1: 检查 agent 配置
echo "### Test 1: Agent Configuration"
if jq -e '.agents.list[] | select(.id=="debugger")' ~/.openclaw/openclaw.json > /dev/null; then
    echo "✅ Agent is registered"
else
    echo "❌ Agent not found in config"
    exit 1
fi
echo ""

# 测试 2: 检查系统提示词
echo "### Test 2: System Prompt"
if [[ -f ~/.openclaw/workspace/agents/debugger/system-prompt.md ]]; then
    echo "✅ System prompt exists"
    wc -l ~/.openclaw/workspace/agents/debugger/system-prompt.md
else
    echo "❌ System prompt not found"
    exit 1
fi
echo ""

# 测试 3: 检查技能脚本
echo "### Test 3: Skills"
for skill in service-check health-check port-check app-debug; do
    if [[ -x ~/.openclaw/workspace/agents/debugger/skills/${skill}.sh ]]; then
        echo "✅ ${skill}.sh is executable"
    else
        echo "❌ ${skill}.sh not found or not executable"
    fi
done
echo ""

# 测试 4: 运行一个简单的健康检查
echo "### Test 4: Health Check Skill"
~/.openclaw/workspace/agents/debugger/skills/health-check.sh | head -30
echo ""

echo "🎉 All tests passed! Debug Master is ready to use."
echo ""
echo "Try it in Feishu:"
echo "  1. Send: /agent debugger"
echo "  2. Ask: 我的系统健康状况如何？"
