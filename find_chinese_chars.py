
# Copyright (c) 2026 Bivex
#
# Author: Bivex
# Available for contact via email: support@b-b.top
# For up-to-date contact information:
# https://github.com/bivex
#
# Created: 2026-01-03T01:29:10
# Last Updated: 2026-01-03T01:29:10
#
# Licensed under the MIT License.
# Commercial licensing available upon request.
"""
Рекурсивный поиск китайских символов в файлах.
Выводит файлы и конкретные строки с китайскими символами.
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple


CHINESE_PATTERN = re.compile(r'[\u4e00-\u9fff]')

SKIP_DIRS = {'.git', '.ruff_cache', '__pycache__', 'node_modules', '.venv', 'venv'}

SKIP_EXTENSIONS = {'.pyc', '.pyo', '.so', '.dylib', '.exe', '.bin', '.jpg', '.png', '.gif', '.ico', '.pdf'}


def find_chinese_in_file(file_path: Path) -> List[Tuple[int, str]]:
    """Находит строки с китайскими символами в файле."""
    matches = []
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            for line_num, line in enumerate(f, start=1):
                if CHINESE_PATTERN.search(line):
                    matches.append((line_num, line.rstrip()))
    except (IOError, OSError):
        pass
    return matches


def scan_directory(root_dir: Path) -> dict:
    """Рекурсивно сканирует директорию."""
    results = {}

    for dirpath, dirnames, filenames in os.walk(root_dir):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]

        for filename in filenames:
            file_path = Path(dirpath) / filename

            if file_path.suffix.lower() in SKIP_EXTENSIONS:
                continue

            matches = find_chinese_in_file(file_path)
            if matches:
                results[file_path] = matches

    return results


def main():
    root_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()

    if not root_dir.exists():
        print(f"Ошибка: директория {root_dir} не существует", file=sys.stderr)
        sys.exit(1)

    print(f"Поиск китайских символов в: {root_dir.absolute()}")
    print("=" * 70)

    results = scan_directory(root_dir)

    if results:
        print(f"\nНайдено файлов: {len(results)}\n")

        for file_path in sorted(results.keys()):
            rel_path = file_path.relative_to(root_dir)
            matches = results[file_path]

            print(f"\n📄 {rel_path} ({len(matches)} строк)")
            print("-" * 70)

            for line_num, line in matches[:10]:
                line_preview = line[:100] + "..." if len(line) > 100 else line
                print(f"  {line_num:4d}: {line_preview}")

            if len(matches) > 10:
                print(f"  ... и ещё {len(matches) - 10} строк")
    else:
        print("\nФайлы с китайскими символами не найдены.")

    return 0 if results else 1


if __name__ == '__main__':
    sys.exit(main())
