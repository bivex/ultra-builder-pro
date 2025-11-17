#!/bin/bash
# Post-Edit Hook - 轻量级代码质量检查
# 在文件编辑后自动触发

set -e

FILE_PATH="$1"

# 如果没有提供文件路径，退出
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# 获取文件扩展名
EXT="${FILE_PATH##*.}"

# 根据文件类型执行不同检查
case "$EXT" in
  js|jsx|ts|tsx)
    # JavaScript/TypeScript - 检查是否有eslint
    if command -v eslint &> /dev/null; then
      eslint --quiet --format compact "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  py)
    # Python - 检查是否有flake8
    if command -v flake8 &> /dev/null; then
      flake8 --quiet "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  *)
    # 其他文件类型，不执行检查
    ;;
esac

# 始终返回成功，不阻塞工作流
exit 0
