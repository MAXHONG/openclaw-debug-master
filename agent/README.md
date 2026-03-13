# Debug Master Agent

专业的系统诊断和 Bug 排查专家 Agent。

## 特性

- 🔍 **系统化诊断方法**：遵循科学的排查流程
- 🛠️ **工具优先原则**：总是用实际数据，不猜测
- 📊 **渐进式交互**：一步一步引导用户
- 🎓 **教学式排查**：不仅解决问题，还教会用户

## 使用方法

### 启动 Agent

```bash
# 在飞书或其他频道中切换到 debugger agent
/agent debugger

# 或者在命令行中使用
openclaw chat --agent debugger
```

### 诊断场景

#### 1. 服务问题
"我的 nginx 服务启动不了"
"openclaw-gateway 一直重启"

#### 2. 应用程序错误
"我的 Node.js 程序报错了"
"Python 脚本运行到一半就停了"

#### 3. 网络问题
"我的网站打不开"
"API 请求超时"

#### 4. 性能问题
"系统很卡"
"内存不够用了"

## 内置技能

### 1. service-check.sh
快速检查服务状态、日志和错误信息

```bash
./skills/service-check.sh nginx
./skills/service-check.sh openclaw-gateway --user
```

### 2. health-check.sh
系统整体健康检查

```bash
./skills/health-check.sh
```

### 3. port-check.sh
端口占用和连接诊断

```bash
./skills/port-check.sh 443
./skills/port-check.sh 8080
```

### 4. app-debug.sh
应用程序启动诊断

```bash
./skills/app-debug.sh "node index.js"
./skills/app-debug.sh "python3 app.py"
```

## 诊断流程

Debug Master 遵循标准的诊断流程：

1. **明确问题** - 问清楚具体症状
2. **收集证据** - 用工具获取实际数据
3. **分析根因** - 找到问题根本原因
4. **提出方案** - 给出解决步骤
5. **执行验证** - 修复并确认结果

## 示例对话

**用户**: "我的网站打不开了"

**Debug Master**:
1. 先问："能告诉我域名吗？收到什么错误信息？"
2. 检查：运行 `curl` 测试连接
3. 诊断：检查 Caddy/Nginx 状态和日志
4. 分析：找到具体错误（证书过期？配置错误？）
5. 解决：提供修复步骤并执行

## 配置

Agent 使用 Claude 3.5 Sonnet 作为主模型，确保最佳推理能力。

```json
{
  "model": {
    "primary": "anthropic/claude-3-5-sonnet-20241022",
    "fallbacks": [
      "aliyun/qwen3-coder-plus",
      "aliyun/qwen3.5-plus"
    ]
  }
}
```

## 最佳实践

1. **描述清楚问题**：包括错误信息、操作步骤、预期结果
2. **提供上下文**：最近做了什么改动？什么时候开始的？
3. **跟随引导**：Agent 会一步步引导你排查
4. **学习过程**：理解为什么出现问题，下次如何避免

## 与主 Agent 的区别

| 特性 | Debug Master | 主 Agent (Genspark Claw) |
|------|--------------|--------------------------|
| **专长** | 故障诊断、Bug 排查 | 通用 AI 助手 |
| **思维方式** | 系统化排查流程 | 灵活响应各类请求 |
| **工具使用** | 诊断命令为主 | 全方位工具集 |
| **交互风格** | 渐进式引导 | 直接回答 |

需要帮助？随时呼叫 Debug Master！
