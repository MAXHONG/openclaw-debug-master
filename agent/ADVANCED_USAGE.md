# Debug Master - 高级用法指南

## 📌 当前的使用方式（手动切换）

### 问题回答

**Q1: 切换 Agent 会中断主 Agent 的任务吗？**

A: ❌ **不会中断任务，但会切换会话上下文**

```
你正在跟大G聊天写代码...
├─ 对话历史保存在 main 的 session 中
│
你: /agent debugger          ← 切换到诊断模式
├─ main 的会话被"冻结"保存
├─ 开始新的 debugger 会话
│
你: 帮我排查问题
Debugger: （诊断中...）
│
你: /agent main              ← 切换回主 Agent
├─ debugger 的会话被"冻结"保存
└─ 恢复 main 的会话，继续写代码
```

**结论**：
- ✅ 任务和记忆不会丢失
- ✅ 切换回去可以继续
- ✅ 两个 Agent 的会话独立
- ❌ 切换时不保留跨 Agent 上下文

---

**Q2: 切换后是不是默认都是 debugger 回复？**

A: ✅ **是的，直到你再次切换回来**

```
飞书会话的当前状态：

初始：
└─ 当前 Agent: main
   └─ 所有消息（包括 @大G）都由 main 处理

执行 /agent debugger 后：
└─ 当前 Agent: debugger
   └─ 所有消息（包括 @大G）都由 debugger 处理 ⚠️
   └─ 即使你 @大G，也是 debugger 回复！

执行 /agent main 后：
└─ 当前 Agent: main
   └─ 所有消息又回到 main 处理
```

**重要提醒**：
- ⚠️ 切换到 debugger 后，@大G 也是 debugger 回复
- ⚠️ 你需要手动 /agent main 切回主 Agent
- ✅ 可以随时用 "/status" 查看当前 Agent

---

## 🚀 更好的方案：自动路由（推荐）

OpenClaw 支持**基于关键词或场景自动路由到不同 Agent**，无需手动切换！

### 方案 A：单独的诊断群组（最简单）

创建一个专门的飞书群，绑定到 debugger：

**配置步骤**：

1. **在飞书创建群组**："系统诊断专用群"

2. **获取群组 ID**：
   ```bash
   # 在群里发送任意消息后，查看日志
   journalctl --user -u openclaw-gateway -n 100 --no-pager | grep "chat_id"
   ```

3. **添加路由绑定**：
   ```json
   {
     "bindings": [
       {
         "agentId": "debugger",
         "match": {
           "channel": "feishu",
           "peer": {
             "kind": "group",
             "id": "oc_xxxxx"  // 替换为实际的群组 ID
           }
         }
       }
     ]
   }
   ```

4. **重启 gateway**：
   ```bash
   systemctl --user restart openclaw-gateway
   ```

**效果**：
- ✅ 在"系统诊断专用群"发消息 → 自动由 debugger 处理
- ✅ 在其他群/私聊 → 仍然由 main 处理
- ✅ 无需手动切换 /agent

---

### 方案 B：基于 @提及的智能路由（未来支持）

理想情况（需要等待 OpenClaw 功能增强）：

```
你：@大G 帮我写个函数
→ main 回复（通用任务）

你：@Debug 我的服务挂了
→ debugger 回复（诊断任务）
```

**当前限制**：
- OpenClaw 目前不支持同一频道内基于 @名字 的 Agent 路由
- 只能通过 /agent 手动切换或通过群组/peer 绑定

**替代方案**：
在主 Agent 的 AGENTS.md 中添加提示：

```markdown
当用户明确要求"诊断"、"排查问题"、"查看日志"等任务时，
提醒用户：
"这个问题需要专业的诊断分析。建议你切换到 Debug Master：
/agent debugger"
```

---

### 方案 C：创建快捷命令（推荐）

在主 Agent 中添加技能，快速调用 debugger 的诊断脚本：

```bash
# 在主 Agent 的 skills 目录创建软链接
cd ~/.openclaw/workspace/skills
ln -s ../agents/debugger/skills/service-check.sh debug-service
ln -s ../agents/debugger/skills/health-check.sh debug-health
ln -s ../agents/debugger/skills/port-check.sh debug-port
```

**效果**：
```
你：@大G 检查系统健康
大G：（调用 debug-health 技能）
    [显示系统健康报告]
```

---

## 💡 推荐的使用模式

### 模式 1：临时诊断（最灵活）

```
# 遇到问题时
/agent debugger
（排查完毕）
/agent main
```

**优点**：简单直接
**缺点**：需要手动切换

---

### 模式 2：专用诊断群（最方便）

```
创建群：
├─ "日常交流群" → 绑定 main
└─ "系统诊断群" → 绑定 debugger

使用：
├─ 在"日常交流群"聊天、写代码 → main
└─ 在"系统诊断群"排查问题 → debugger
```

**优点**：自动路由，无需切换
**缺点**：需要创建多个群

---

### 模式 3：混合模式（推荐）

```
日常：在主会话跟大G交流
问题：/agent debugger → 排查 → /agent main
紧急：在专用诊断群直接排查
```

**优点**：灵活 + 方便
**缺点**：需要记住切换

---

## 🎓 使用技巧

### 技巧 1：检查当前 Agent

不确定当前是哪个 Agent？发送：

```
/status

或

你是谁？
```

### 技巧 2：快速切换

设置飞书快捷短语：
- 输入 "dm" → 自动展开为 "/agent debugger"
- 输入 "am" → 自动展开为 "/agent main"

### 技巧 3：直接使用诊断脚本

不想切换 Agent？直接让主 Agent 执行脚本：

```
你：@大G 帮我运行这个命令：
~/.openclaw/workspace/agents/debugger/skills/health-check.sh
```

### 技巧 4：创建专用频道

如果你用多个消息平台（飞书 + Telegram）：
- 飞书 → main（日常工作）
- Telegram → debugger（系统监控）

配置：
```json
{
  "bindings": [
    { "agentId": "main", "match": { "channel": "feishu" } },
    { "agentId": "debugger", "match": { "channel": "telegram" } }
  ]
}
```

---

## 📚 配置示例

### 示例 1：专用诊断群配置

```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "identity": { "name": "Genspark Claw" }
      },
      {
        "id": "debugger",
        "identity": { "name": "Debug Master" },
        "workspace": "/home/work/.openclaw/workspace/agents/debugger",
        "model": {
          "primary": "aliyun/qwen3-coder-plus"
        }
      }
    ]
  },
  "bindings": [
    {
      "agentId": "debugger",
      "match": {
        "channel": "feishu",
        "peer": {
          "kind": "group",
          "id": "oc_xxxxxxxxxxxxx"
        }
      }
    }
  ]
}
```

### 示例 2：多群路由配置

```json
{
  "bindings": [
    {
      "agentId": "debugger",
      "match": {
        "channel": "feishu",
        "peer": { "kind": "group", "id": "oc_debug_group" }
      }
    },
    {
      "agentId": "main",
      "match": {
        "channel": "feishu",
        "peer": { "kind": "group", "id": "oc_work_group" }
      }
    },
    {
      "agentId": "main",
      "match": { "channel": "feishu" }
    }
  ]
}
```

---

## 🆘 常见问题

**Q: 我切换到 debugger 后忘记切回来了怎么办？**

A: 没关系，发送 `/agent main` 随时切回。或者直接问"你是谁"，如果回答是 Debug Master，就知道需要切换了。

**Q: 能不能让大G自动判断什么时候调用 debugger？**

A: 目前 OpenClaw 不支持"主 Agent 自动调用子 Agent"。但你可以：
1. 在主 Agent 的提示词中添加提醒
2. 使用专用群组绑定（方案 A）
3. 创建技能快捷方式（方案 C）

**Q: debugger 能访问 main 的记忆吗？**

A: 不能。两个 Agent 的会话和记忆是完全独立的。这是为了隔离和安全。

**Q: 我能删除 debugger 吗？**

A: 可以！参考 SUMMARY.md 中的"如果出问题"部分。删除后主 Agent 完全不受影响。

---

需要帮助配置自动路由？告诉我你的需求！
