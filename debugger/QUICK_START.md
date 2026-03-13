# Debug Master 快速开始指南

## 🚀 如何使用

### 在飞书中使用

1. **切换到 Debug Master**
   ```
   /agent debugger
   ```

2. **开始诊断**
   - "检查系统状态"
   - "为什么我的服务启动不了？"
   - "端口 8080 被什么占用了？"
   - "系统内存使用情况如何？"

3. **切换回主 Agent**
   ```
   /agent main
   ```

### 在命令行中使用

```bash
# 启动 debugger agent 的交互式会话
openclaw chat --agent debugger

# 单次查询
openclaw chat --agent debugger "检查系统健康状态"
```

## 📚 常见使用场景

### 场景 1：服务无法启动

**你**: "我的 openclaw-gateway 服务启动不了"

**Debug Master 会**:
1. 检查服务状态
2. 查看最近的日志
3. 分析错误信息
4. 找出根本原因（端口占用？配置错误？权限问题？）
5. 提供修复步骤

### 场景 2：网站打不开

**你**: "我的网站访问不了"

**Debug Master 会**:
1. 测试网络连通性
2. 检查 Caddy/Nginx 状态
3. 查看 SSL 证书
4. 检查防火墙规则
5. 定位问题并给出解决方案

### 场景 3：应用程序报错

**你**: "我的 Node.js 程序报错了：Cannot find module 'express'"

**Debug Master 会**:
1. 检查 Node.js 版本
2. 检查 package.json
3. 检查 node_modules 是否存在
4. 告诉你运行 `npm install`
5. 验证修复结果

### 场景 4：性能问题

**你**: "系统很卡，怎么回事？"

**Debug Master 会**:
1. 检查 CPU 和内存使用
2. 查看占用资源最多的进程
3. 检查磁盘空间
4. 分析是否有异常进程
5. 给出优化建议

## 🛠️ 直接使用诊断工具

Debug Master 自带的诊断脚本也可以直接运行：

```bash
cd ~/.openclaw/workspace/agents/debugger/skills

# 检查服务
./service-check.sh nginx
./service-check.sh openclaw-gateway --user

# 系统健康检查
./health-check.sh

# 端口诊断
./port-check.sh 443
./port-check.sh 8080

# 应用启动诊断
./app-debug.sh "node index.js"
./app-debug.sh "python3 app.py"
```

## 💡 技巧

1. **描述越详细越好**
   - ❌ "不工作了"
   - ✅ "运行 npm start 时报错：Error: listen EADDRINUSE :::3000"

2. **提供上下文**
   - "之前还好的，今天早上开始就不行了"
   - "我刚刚修改了配置文件"
   - "重启服务器后就这样了"

3. **跟随引导**
   - Debug Master 会一步步引导你
   - 每个步骤都会解释原因
   - 不懂的地方随时问

4. **学习过程**
   - 理解为什么会出现问题
   - 记住解决方法
   - 下次可以自己排查

## 🎯 Debug Master 的优势

| 特点 | 说明 |
|------|------|
| **系统化** | 遵循科学的诊断流程，不遗漏任何环节 |
| **工具优先** | 总是用实际数据验证，不猜测 |
| **教学式** | 不仅解决问题，还教会你原理 |
| **渐进式** | 一步一步引导，不会一次性输出大量信息 |
| **专业性** | 精通 Linux、网络、数据库、编程语言等多个领域 |

## 🔄 与主 Agent 配合使用

Debug Master 专注于诊断，其他任务还是主 Agent 更擅长：

| 任务类型 | 推荐 Agent |
|---------|-----------|
| 故障排查、Bug 调试 | 🔍 Debug Master |
| 代码开发、文件操作 | 🤖 主 Agent |
| 网络搜索、信息查询 | 🤖 主 Agent |
| 图片生成、视频创作 | 🤖 主 Agent |
| 系统监控、日志分析 | 🔍 Debug Master |

## 📞 需要帮助？

在飞书中随时呼叫 Debug Master：

```
/agent debugger
帮我诊断一下系统
```

Debug Master 随时待命！🚀
