# Debug Master Agent - 配置总结

## ✅ 已完成

### 1. Agent 创建
- **ID**: `debugger`
- **名称**: Debug Master
- **类型**: 子 Agent（不影响主 Agent）

### 2. 模型配置
根据您的需求，选择了完全不使用 Genspark LLM 代理的模型：

```json
{
  "primary": "aliyun/qwen3-coder-plus",
  "fallbacks": [
    "minimax/MiniMax-M2.5-highspeed",
    "tencent/hunyuan-2.0-thinking",
    "aliyun/qwen3.5-plus"
  ]
}
```

**为什么选择 Qwen3-Coder-Plus？**
- ⭐ 专为编码和调试任务设计
- ⭐ 1M token 上下文窗口
- ⭐ 完整的工具调用能力
- ⭐ 在 2026 中国编码 LLM 中表现顶级
- ⭐ 快速响应，适合实时诊断
- ⭐ 成本比 Claude 低很多

### 3. 系统提示词
249 行专业的诊断思维框架，包括：
- 系统化的诊断方法论（5步流程）
- 常见场景诊断模板
- 工具优先原则
- 渐进式交互策略
- 教学式排查方法

### 4. 诊断技能（Skills）
4 个实用的 Shell 脚本：
1. **service-check.sh** - 服务状态全面诊断
2. **health-check.sh** - 系统健康检查
3. **port-check.sh** - 端口占用分析
4. **app-debug.sh** - 应用启动诊断

### 5. 文件结构
```
~/.openclaw/workspace/agents/debugger/
├── agent.json              # Agent 配置
├── system-prompt.md        # 诊断思维框架（249行）
├── README.md               # 详细说明文档
├── QUICK_START.md          # 快速开始指南
├── SUMMARY.md              # 本文件
├── test-debugger.sh        # 测试脚本
└── skills/                 # 诊断技能库
    ├── service-check.sh
    ├── health-check.sh
    ├── port-check.sh
    └── app-debug.sh
```

## 🔄 与主 Agent 的关系

```
您的 OpenClaw
├── main (主 Agent)
│   ├── 所有现有功能不变
│   ├── 所有记忆不变
│   └── 所有技能不变
│
└── debugger (新增子 Agent)
    ├── 独立的诊断能力
    ├── 独立的工作目录
    └── 可随时切换使用
```

**重要**：
- ❌ 没有删除任何东西
- ❌ 没有修改主 Agent
- ✅ 只是添加了一个新选项
- ✅ 主 Agent 完全不受影响

## 📱 如何使用

### 在飞书中
```
# 切换到诊断模式
/agent debugger

# 提问
我的服务启动不了，帮我排查

# 切换回主 Agent
/agent main
```

### 在命令行
```bash
# 交互式会话
openclaw chat --agent debugger

# 单次查询
openclaw chat --agent debugger "检查系统状态"
```

### 直接使用诊断脚本
```bash
cd ~/.openclaw/workspace/agents/debugger/skills

# 检查服务
./service-check.sh openclaw-gateway --user

# 系统健康检查
./health-check.sh

# 端口诊断
./port-check.sh 443
```

## 🎯 适用场景

| 场景 | 使用 Agent |
|------|-----------|
| 服务启动失败 | 🔍 debugger |
| 应用程序报错 | 🔍 debugger |
| 网络连接问题 | 🔍 debugger |
| 性能问题排查 | 🔍 debugger |
| 日志分析 | 🔍 debugger |
| 配置验证 | 🔍 debugger |
| 代码开发 | 🤖 main |
| 内容创作 | 🤖 main |
| 信息查询 | 🤖 main |
| 图片生成 | 🤖 main |

## 💰 成本对比

使用 Qwen3-Coder-Plus vs Claude 3.5 Sonnet：

| 项目 | Qwen3-Coder-Plus | Claude 3.5 (通过 Genspark) |
|------|------------------|---------------------------|
| 输入成本 | 很低 | 较高 |
| 输出成本 | 很低 | 较高 |
| 速度 | 快 | 中等 |
| 编码能力 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 调试能力 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

**结论**：Qwen3-Coder-Plus 在诊断场景下性能相当，成本更低！

## 🚀 下一步

1. **重启 gateway**（需要您确认）
   ```bash
   systemctl --user restart openclaw-gateway
   ```

2. **测试 Debug Master**
   - 在飞书发送：`/agent debugger`
   - 提问：`检查系统状态`

3. **探索功能**
   - 尝试不同类型的诊断问题
   - 查看它的系统化排查流程
   - 学习它教给你的调试技巧

## 📚 文档

- [README.md](./README.md) - 完整功能介绍
- [QUICK_START.md](./QUICK_START.md) - 快速开始指南
- [system-prompt.md](./system-prompt.md) - 诊断思维框架

## 🆘 如果出问题

Debug Master 是独立的，可以随时删除：

```bash
# 从配置中移除
jq 'del(.agents.list[] | select(.id=="debugger"))' \
  ~/.openclaw/openclaw.json > ~/.openclaw/openclaw.json.new
mv ~/.openclaw/openclaw.json.new ~/.openclaw/openclaw.json

# 删除文件
rm -rf ~/.openclaw/workspace/agents/debugger/

# 重启
systemctl --user restart openclaw-gateway
```

主 Agent 完全不受影响！

---

**准备好了吗？输入"是"重启 gateway 来激活 Debug Master！** 🚀
