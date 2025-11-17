# Ultra Builder Pro 4.0 安装指南

**版本**: 4.0.1 (Modular Edition)
**发布日期**: 2025-10-28
**适用于**: Claude Code 用户

---

## 快速安装（推荐）

### 方法 1: 一键安装脚本（最快）

```bash
# 进入解压后的目录
cd Ultra-Builder-Pro-4.0

# 运行安装脚本
./install.sh
```

安装脚本会自动：
- ✅ 备份现有 ~/.claude/ 目录（如果存在）
- ✅ 复制所有文件到正确位置
- ✅ 验证安装完整性
- ✅ 显示安装结果

---

### 方法 2: 手动安装（精细控制）

#### 步骤 1: 备份现有配置（如果有）

```bash
# 如果您已有 ~/.claude/ 配置，建议先备份
mv ~/.claude ~/.claude.backup-$(date +%Y%m%d-%H%M%S)
```

#### 步骤 2: 复制文件

```bash
# 从解压后的目录复制到用户目录
cp -r Ultra-Builder-Pro-4.0/.claude ~/
```

#### 步骤 3: 验证安装

```bash
# 检查主文件
ls -lh ~/.claude/CLAUDE.md

# 检查模块目录
ls ~/.claude/guidelines/
ls ~/.claude/config/
ls ~/.claude/workflows/

# 检查 Skills
ls ~/.claude/skills/

# 检查 Agents
ls ~/.claude/agents/

# 检查 Commands
ls ~/.claude/commands/
```

**预期输出**:
```
~/.claude/
├── CLAUDE.md (331 行)
├── guidelines/ (3 个文件)
├── config/ (2 个文件)
├── workflows/ (2 个文件)
├── skills/ (9 个 skills)
├── agents/ (4 个 agents)
└── commands/ (7 个 commands)
```

---

## 系统要求

### 必需条件

- ✅ **Claude Code**: 已安装并配置
- ✅ **操作系统**: macOS, Linux, 或 Windows (WSL)
- ✅ **磁盘空间**: 至少 5MB 可用空间

### 可选条件（功能增强）

- 🔵 **Git**: 用于版本控制和工作流管理
- 🔵 **Node.js**: 如果使用 JavaScript/TypeScript 项目
- 🔵 **Python**: 如果使用 Python 项目

---

## 安装后验证

### 验证 1: 检查文件数量

```bash
# 主文件
wc -l ~/.claude/CLAUDE.md
# 预期: 331 行

# 模块文件
wc -l ~/.claude/guidelines/*.md
wc -l ~/.claude/config/*.md
wc -l ~/.claude/workflows/*.md
# 预期: 7 个文件，总计约 3000+ 行

# Skills
ls ~/.claude/skills/ | wc -l
# 预期: 9 个 skills

# Agents
ls ~/.claude/agents/ | wc -l
# 预期: 4 个 agents

# Commands
ls ~/.claude/commands/ | wc -l
# 预期: 7 个 commands
```

### 验证 2: 测试 Claude Code

```bash
# 启动 Claude Code
claude

# 在 Claude Code 中输入测试命令
/ultra-status
```

**预期行为**:
- ✅ Claude 读取 CLAUDE.md（包含模块化配置）
- ✅ 9 个 Skills 自动加载
- ✅ `/ultra-status` 命令可用

---

## 配置说明

### 文件结构说明

```
~/.claude/
├── CLAUDE.md                           # 主配置文件（331 行）
├── CLAUDE.md.backup-pre-modular        # 优化前备份（464 行）
│
├── guidelines/                         # 开发指南（原则和标准）
│   ├── solid-principles.md             # SOLID/DRY/KISS/YAGNI 详解
│   ├── quality-standards.md            # 质量标准（测试、前端、代码）
│   └── git-workflow.md                 # Git 工作流规范
│
├── config/                             # 工具配置（Skills 和 MCP）
│   ├── skills-guide.md                 # 9 个 Skills 完整指南
│   └── mcp-integration.md              # MCP 决策树 + 使用模式
│
├── workflows/                          # 工作流程（开发和优化）
│   ├── development-workflow.md         # 7 阶段完整工作流
│   └── context-management.md           # 上下文优化策略
│
├── skills/                             # 9 个自动化 Skills
│   ├── code-quality-guardian/
│   ├── git-workflow-guardian/
│   ├── ui-design-guardian/
│   ├── performance-guardian/
│   ├── documentation-guardian/
│   ├── test-strategy-guardian/
│   ├── context-overflow-handler/
│   ├── file-operations-guardian/
│   └── workflow-guide/
│
├── agents/                             # 4 个专业 Agents
│   ├── ultra-research-agent.md
│   ├── ultra-architect-agent.md
│   ├── ultra-performance-agent.md
│   └── ultra-qa-agent.md
│
└── commands/                           # 7 个工作流命令
    ├── ultra-init.md
    ├── ultra-research.md
    ├── ultra-plan.md
    ├── ultra-dev.md
    ├── ultra-test.md
    ├── ultra-deliver.md
    └── ultra-status.md
```

### @ 引用说明

主 CLAUDE.md 使用 @ 语法引用模块文件：

```markdown
**Complete guide**: @guidelines/solid-principles.md
```

**工作原理**:
- Claude Code 会自动解析 @ 引用
- 按需加载被引用的文件内容
- 最大深度: 5 hops（当前使用 1 hop）

### 自定义配置

如需个性化配置：

1. **保留全局配置**: `~/.claude/CLAUDE.md`（所有项目共享）
2. **项目特定配置**: 在项目根目录创建 `.claude/CLAUDE.md`
3. **个人变体**: 创建 `.claude/CLAUDE.local.md`（添加到 .gitignore）

**优先级**: 项目配置 > 个人配置 > 全局配置

---

## 升级现有安装

如果您之前安装过旧版本：

### 步骤 1: 备份现有配置

```bash
# 备份整个 .claude 目录
cp -r ~/.claude ~/.claude.backup-$(date +%Y%m%d-%H%M%S)
```

### 步骤 2: 对比差异（可选）

```bash
# 对比主文件
diff ~/.claude/CLAUDE.md ~/Desktop/Ultra-Builder-Pro-4.0/.claude/CLAUDE.md

# 如果有自定义修改，需要手动合并
```

### 步骤 3: 安装新版本

```bash
# 删除旧版本（已备份）
rm -rf ~/.claude

# 安装新版本
cp -r Ultra-Builder-Pro-4.0/.claude ~/
```

### 步骤 4: 恢复自定义内容（如有）

```bash
# 从备份中恢复特定文件或配置
# 例如：自定义的 CLAUDE.local.md
cp ~/.claude.backup-XXXXXX/.claude/CLAUDE.local.md ~/.claude/
```

---

## 卸载

如需完全卸载 Ultra Builder Pro 4.0：

```bash
# 备份（以防万一）
cp -r ~/.claude ~/.claude.backup-$(date +%Y%m%d-%H%M%S)

# 删除 Ultra Builder Pro
rm -rf ~/.claude

# 如需恢复 Claude Code 默认配置
# Claude Code 会在下次启动时使用默认配置
```

---

## 故障排查

### 问题 1: CLAUDE.md 未被加载

**症状**: Claude Code 启动后没有加载配置

**诊断**:
```bash
# 检查文件是否存在
ls -lh ~/.claude/CLAUDE.md

# 检查文件权限
ls -l ~/.claude/CLAUDE.md
# 应该可读（rw-r--r--）
```

**解决**:
```bash
# 确保文件权限正确
chmod 644 ~/.claude/CLAUDE.md

# 重启 Claude Code
```

---

### 问题 2: @ 引用无法解析

**症状**: 看到 `@guidelines/solid-principles.md` 但内容未加载

**诊断**:
```bash
# 检查模块文件是否存在
ls ~/.claude/guidelines/solid-principles.md

# 检查文件路径
pwd
# 确保在正确的目录
```

**解决**:
```bash
# 确保所有模块文件都已复制
cp -r Ultra-Builder-Pro-4.0/.claude/guidelines ~/. claude/
cp -r Ultra-Builder-Pro-4.0/.claude/config ~/.claude/
cp -r Ultra-Builder-Pro-4.0/.claude/workflows ~/.claude/
```

---

### 问题 3: Skills 未触发

**症状**: 编辑代码时 code-quality-guardian 没有触发

**诊断**:
```bash
# 检查 Skills 目录
ls ~/.claude/skills/
# 应该看到 9 个目录

# 检查特定 Skill
cat ~/.claude/skills/code-quality-guardian/SKILL.md | head -20
```

**解决**:
```bash
# 确保所有 Skills 已复制
cp -r Ultra-Builder-Pro-4.0/.claude/skills ~/.claude/

# 重启 Claude Code
```

---

### 问题 4: Commands 不可用

**症状**: `/ultra-status` 命令无法识别

**诊断**:
```bash
# 检查 Commands 目录
ls ~/.claude/commands/
# 应该看到 7 个 .md 文件
```

**解决**:
```bash
# 确保所有 Commands 已复制
cp -r Ultra-Builder-Pro-4.0/.claude/commands ~/.claude/

# 重启 Claude Code
```

---

## 技术支持

### 查看文档

- **用户指南**: `docs/ULTRA_BUILDER_PRO_4.0_USER_GUIDE.md`
- **完成报告**: `docs/modularization_completion_report.md`
- **验证报告**: `docs/comprehensive_verification_report.md`

### 常见问题

参考用户指南第 7 章"故障排查"部分。

### 社区支持

- GitHub Issues: [报告问题]
- 官方文档: https://docs.claude.com/en/docs/claude-code

---

## 版本信息

**Ultra Builder Pro 4.0.1 (Modular Edition)**

**更新内容**:
- ✅ 模块化文档结构（7 个模块文件）
- ✅ Token 消耗降低 28.6%
- ✅ 工作流前置到第 36 行
- ✅ 完整 Skills 和 MCP 指南
- ✅ 解决 4 个核心问题

**变更日志**:
- 2025-10-28: v4.0.1 - 模块化重构
- 2025-10-25: v4.0 - 官方文档合规化

---

**安装完成后，请参考 README.md 快速开始使用！**
