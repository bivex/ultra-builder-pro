#!/usr/bin/env python3
"""
Documentation Synchronization Script

Checks alignment between documentation and code.

Usage:
    python doc_sync.py check  # Check for drift
"""

import re
import sys
from pathlib import Path
from typing import Dict


class DocSyncManager:
    """Manages documentation synchronization."""

    def __init__(self, project_path: str = "."):
        self.project_path = Path(project_path).resolve()
        self.specs_dir = self.project_path / ".ultra" / "specs"
        self.legacy_docs_dir = self.project_path / "docs"

    def check_drift(self) -> Dict:
        """Check for documentation drift."""
        result = {
            "specs_found": [],
            "missing_docs": [],
            "stale_markers": [],
            "warnings": [],
            "recommendations": []
        }

        # Check .ultra/specs directory
        if self.specs_dir.exists():
            for doc in self.specs_dir.glob("*.md"):
                result["specs_found"].append(str(doc.relative_to(self.project_path)))
                self._check_stale_markers(doc, result)

        # Check legacy docs
        if self.legacy_docs_dir.exists():
            for doc in self.legacy_docs_dir.glob("*.md"):
                result["specs_found"].append(str(doc.relative_to(self.project_path)))
                self._check_stale_markers(doc, result)

        # Check for common missing docs
        expected_docs = [
            (".ultra/specs/product.md", "Product requirements"),
            (".ultra/specs/architecture.md", "Architecture decisions"),
        ]

        for path, description in expected_docs:
            if not (self.project_path / path).exists():
                # Check legacy location
                legacy_paths = [
                    path.replace(".ultra/specs/", "docs/"),
                    path.replace("product.md", "prd.md"),
                    path.replace("architecture.md", "tech.md"),
                ]
                found = any((self.project_path / lp).exists() for lp in legacy_paths)
                if not found:
                    result["missing_docs"].append(f"{path} ({description})")

        # Generate recommendations
        if result["stale_markers"]:
            result["recommendations"].append("Review and resolve [NEEDS CLARIFICATION] markers")

        if result["missing_docs"]:
            result["recommendations"].append("Create missing specification documents")

        return result

    def _check_stale_markers(self, doc_path: Path, result: Dict):
        """Check for stale markers in documentation."""
        try:
            content = doc_path.read_text()
            markers = [
                r'\[NEEDS CLARIFICATION\]',
                r'\[TODO\]',
                r'\[TBD\]',
                r'\[PENDING\]',
            ]

            for marker in markers:
                matches = re.findall(marker, content, re.IGNORECASE)
                if matches:
                    result["stale_markers"].append({
                        "file": str(doc_path.relative_to(self.project_path)),
                        "marker": matches[0],
                        "count": len(matches)
                    })
        except:
            pass


def format_drift_report(result: Dict) -> str:
    """Format drift check report."""
    lines = [
        "",
        "=" * 50,
        "文档同步检查",
        "=" * 50,
        "",
    ]

    if result["specs_found"]:
        lines.append("发现的规格文档:")
        for spec in result["specs_found"]:
            lines.append(f"  ✅ {spec}")
        lines.append("")

    if result["missing_docs"]:
        lines.append("缺少的文档:")
        for doc in result["missing_docs"]:
            lines.append(f"  ⚠️  {doc}")
        lines.append("")

    if result["stale_markers"]:
        lines.append("待处理标记:")
        for marker in result["stale_markers"]:
            lines.append(f"  ⚠️  {marker['file']}: {marker['count']}x {marker['marker']}")
        lines.append("")

    if result["recommendations"]:
        lines.append("建议:")
        for rec in result["recommendations"]:
            lines.append(f"  → {rec}")

    lines.append("")
    lines.append("=" * 50)

    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        print("Usage: python doc_sync.py check")
        sys.exit(1)

    manager = DocSyncManager()
    command = sys.argv[1]

    if command == "check":
        result = manager.check_drift()
        print(format_drift_report(result))
    else:
        print(f"Unknown command: {command}")
        print("Usage: python doc_sync.py check")
        sys.exit(1)


if __name__ == "__main__":
    main()
