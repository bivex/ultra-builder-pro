#!/bin/bash

# Ultra Builder Pro 4.0 安装脚本
# 版本: 4.0.1 (Modular Edition)

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 检查是否在正确的目录
check_directory() {
    if [ ! -d ".claude" ]; then
        print_error "错误: 未找到 .claude 目录"
        print_info "请确保在 Ultra-Builder-Pro-4.0 目录中运行此脚本"
        exit 1
    fi
    print_success "目录检查通过"
}

# 备份现有配置
backup_existing() {
    if [ -d "$HOME/.claude" ]; then
        BACKUP_DIR="$HOME/.claude.backup-$(date +%Y%m%d-%H%M%S)"
        print_warning "检测到现有 ~/.claude/ 目录"
        echo -n "是否备份现有配置？(y/n) [y]: "
        read -r response
        response=${response:-y}

        if [[ "$response" =~ ^[Yy]$ ]]; then
            print_info "正在备份到: $BACKUP_DIR"
            cp -r "$HOME/.claude" "$BACKUP_DIR"
            print_success "备份完成: $BACKUP_DIR"
        else
            print_warning "跳过备份"
        fi
    else
        print_info "未检测到现有配置，无需备份"
    fi
}

# 复制文件
install_files() {
    print_info "开始安装 Ultra Builder Pro 4.0..."

    # 创建目标目录
    mkdir -p "$HOME/.claude"

    # 复制所有文件
    cp -r .claude/* "$HOME/.claude/"

    print_success "文件复制完成"
}

# 验证安装
verify_installation() {
    local errors=0

    print_info "验证安装..."

    # 检查主文件
    if [ -f "$HOME/.claude/CLAUDE.md" ]; then
        local lines=$(wc -l < "$HOME/.claude/CLAUDE.md")
        if [ "$lines" -eq 331 ]; then
            print_success "主文件 CLAUDE.md: $lines 行 ✓"
        else
            print_warning "主文件 CLAUDE.md: $lines 行（预期 331 行）"
        fi
    else
        print_error "主文件 CLAUDE.md 缺失"
        ((errors++))
    fi

    # 检查模块目录
    for dir in guidelines config workflows; do
        if [ -d "$HOME/.claude/$dir" ]; then
            local count=$(ls "$HOME/.claude/$dir"/*.md 2>/dev/null | wc -l)
            print_success "模块目录 $dir/: $count 个文件 ✓"
        else
            print_error "模块目录 $dir/ 缺失"
            ((errors++))
        fi
    done

    # 检查 Skills
    if [ -d "$HOME/.claude/skills" ]; then
        local count=$(ls -d "$HOME/.claude/skills"/*/ 2>/dev/null | wc -l)
        if [ "$count" -eq 9 ]; then
            print_success "Skills: $count 个 ✓"
        else
            print_warning "Skills: $count 个（预期 9 个）"
        fi
    else
        print_error "Skills 目录缺失"
        ((errors++))
    fi

    # 检查 Agents
    if [ -d "$HOME/.claude/agents" ]; then
        local count=$(ls "$HOME/.claude/agents"/*.md 2>/dev/null | wc -l)
        if [ "$count" -eq 4 ]; then
            print_success "Agents: $count 个 ✓"
        else
            print_warning "Agents: $count 个（预期 4 个）"
        fi
    else
        print_error "Agents 目录缺失"
        ((errors++))
    fi

    # 检查 Commands
    if [ -d "$HOME/.claude/commands" ]; then
        local count=$(ls "$HOME/.claude/commands"/*.md 2>/dev/null | wc -l)
        if [ "$count" -eq 7 ]; then
            print_success "Commands: $count 个 ✓"
        else
            print_warning "Commands: $count 个（预期 7 个）"
        fi
    else
        print_error "Commands 目录缺失"
        ((errors++))
    fi

    return $errors
}

# 显示安装后信息
show_post_install() {
    print_header "安装完成！"

    echo ""
    echo "📦 已安装组件:"
    echo "   • CLAUDE.md (331 行，模块化主文件)"
    echo "   • 3 个 Guidelines 模块"
    echo "   • 2 个 Config 模块"
    echo "   • 2 个 Workflows 模块"
    echo "   • 9 个 Skills（自动化质量守卫）"
    echo "   • 4 个 Agents（专业领域专家）"
    echo "   • 7 个 Commands（工作流命令）"
    echo ""

    print_info "下一步操作:"
    echo "   1. 启动 Claude Code:"
    echo "      $ claude"
    echo ""
    echo "   2. 测试安装:"
    echo "      在 Claude Code 中输入: /ultra-status"
    echo ""
    echo "   3. 查看完整文档:"
    echo "      $ cat docs/ULTRA_BUILDER_PRO_4.0_USER_GUIDE.md"
    echo ""

    print_success "Ultra Builder Pro 4.0 已准备就绪！ 🚀"
}

# 主函数
main() {
    print_header "Ultra Builder Pro 4.0 安装程序"
    echo ""
    echo "版本: 4.0.1 (Modular Edition)"
    echo "目标: ~/.claude/"
    echo ""

    # 执行安装步骤
    check_directory
    echo ""

    backup_existing
    echo ""

    install_files
    echo ""

    if verify_installation; then
        echo ""
        show_post_install
        exit 0
    else
        echo ""
        print_error "安装验证失败，请检查错误信息"
        print_info "如需帮助，请参考 INSTALLATION.md"
        exit 1
    fi
}

# 运行主函数
main "$@"
