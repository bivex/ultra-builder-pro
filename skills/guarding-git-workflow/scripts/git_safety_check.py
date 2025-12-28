#!/usr/bin/env python3
"""
Git Safety Check Script

Analyzes git operations for potential risks before execution.

Usage:
    python git_safety_check.py <git-command>
    python git_safety_check.py "git push --force origin main"
    python git_safety_check.py --analyze-repo
    python git_safety_check.py --parallel-status
"""

import subprocess
import sys
import re
from dataclasses import dataclass
from enum import Enum
from typing import List, Optional, Tuple


class RiskLevel(Enum):
    SAFE = "SAFE"
    CAUTION = "CAUTION"
    DANGEROUS = "DANGEROUS"
    BLOCKED = "BLOCKED"


@dataclass
class RiskAssessment:
    level: RiskLevel
    command: str
    warnings: List[str]
    recommendations: List[str]
    requires_confirmation: bool


class GitSafetyChecker:
    """Analyzes git commands for safety risks."""

    # High-risk patterns
    DANGEROUS_PATTERNS = [
        (r'push\s+--force\s+origin\s+(main|master)',
         "Force push to main/master rewrites shared history",
         ["Use --force-with-lease instead", "Coordinate with team first"]),

        (r'push\s+-f\s+origin\s+(main|master)',
         "Force push to main/master rewrites shared history",
         ["Use --force-with-lease instead", "Coordinate with team first"]),

        (r'reset\s+--hard\s+HEAD~',
         "Hard reset discards commits permanently",
         ["Ensure commits are backed up", "Consider git revert instead"]),

        (r'reset\s+--hard\s+origin/',
         "Hard reset to remote discards local changes",
         ["Stash changes first: git stash", "Verify no important uncommitted work"]),

        (r'clean\s+-fd',
         "Removes untracked files and directories permanently",
         ["Review untracked files first: git status", "Consider git stash -u"]),

        (r'branch\s+-D',
         "Force deletes branch even if not merged",
         ["Use -d for safe delete", "Verify branch is merged or backed up"]),
    ]

    # Caution patterns
    CAUTION_PATTERNS = [
        (r'rebase\s+',
         "Rebase rewrites commit history",
         ["Ensure branch is not shared", "Consider merge for shared branches"]),

        (r'push\s+--force-with-lease',
         "Force push with lease is safer but still rewrites history",
         ["Verify no one else has pushed", "Communicate with team"]),

        (r'cherry-pick\s+',
         "Cherry-pick may cause duplicate commits",
         ["Document the cherry-pick", "Consider if merge is better"]),

        (r'stash\s+drop',
         "Permanently removes stashed changes",
         ["Verify stash content first: git stash show -p"]),
    ]

    def analyze_command(self, command: str) -> RiskAssessment:
        """Analyze a git command for safety risks."""
        warnings = []
        recommendations = []
        level = RiskLevel.SAFE
        requires_confirmation = False

        # Check dangerous patterns
        for pattern, warning, recs in self.DANGEROUS_PATTERNS:
            if re.search(pattern, command, re.IGNORECASE):
                level = RiskLevel.DANGEROUS
                warnings.append(warning)
                recommendations.extend(recs)
                requires_confirmation = True

        # Check caution patterns (only if not already dangerous)
        if level == RiskLevel.SAFE:
            for pattern, warning, recs in self.CAUTION_PATTERNS:
                if re.search(pattern, command, re.IGNORECASE):
                    level = RiskLevel.CAUTION
                    warnings.append(warning)
                    recommendations.extend(recs)

        return RiskAssessment(
            level=level,
            command=command,
            warnings=warnings,
            recommendations=recommendations,
            requires_confirmation=requires_confirmation
        )

    def analyze_repo_state(self) -> dict:
        """Analyze current repository state for potential issues."""
        results = {
            "branch": self._get_current_branch(),
            "uncommitted_changes": self._has_uncommitted_changes(),
            "unpushed_commits": self._count_unpushed_commits(),
            "stash_count": self._count_stashes(),
            "warnings": [],
            "recommendations": []
        }

        # Check for issues
        if results["uncommitted_changes"]:
            results["warnings"].append("Uncommitted changes detected")
            results["recommendations"].append("Commit or stash changes before risky operations")

        if results["unpushed_commits"] > 5:
            results["warnings"].append(f"{results['unpushed_commits']} unpushed commits")
            results["recommendations"].append("Consider pushing more frequently")

        if results["branch"] in ["main", "master"]:
            results["warnings"].append("Working directly on main/master branch")
            results["recommendations"].append("Create a feature branch for changes")

        return results

    def _get_current_branch(self) -> str:
        try:
            result = subprocess.run(
                ["git", "branch", "--show-current"],
                capture_output=True, text=True, check=True
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError:
            return "unknown"

    def _has_uncommitted_changes(self) -> bool:
        try:
            result = subprocess.run(
                ["git", "status", "--porcelain"],
                capture_output=True, text=True, check=True
            )
            return bool(result.stdout.strip())
        except subprocess.CalledProcessError:
            return False

    def _count_unpushed_commits(self) -> int:
        try:
            result = subprocess.run(
                ["git", "rev-list", "--count", "@{u}..HEAD"],
                capture_output=True, text=True, check=True
            )
            return int(result.stdout.strip())
        except subprocess.CalledProcessError:
            return 0

    def _count_stashes(self) -> int:
        try:
            result = subprocess.run(
                ["git", "stash", "list"],
                capture_output=True, text=True, check=True
            )
            return len(result.stdout.strip().split('\n')) if result.stdout.strip() else 0
        except subprocess.CalledProcessError:
            return 0

    def analyze_parallel_status(self) -> dict:
        """Analyze parallel development branches status."""
        results = {
            "main_branch": self._get_main_branch(),
            "current_branch": self._get_current_branch(),
            "feature_branches": [],
            "potential_conflicts": [],
            "recommendations": []
        }

        # Get all feature branches (local and remote)
        branches = self._get_feature_branches()

        for branch in branches:
            branch_info = self._get_branch_info(branch, results["main_branch"])
            if branch_info:
                results["feature_branches"].append(branch_info)

        # Detect potential conflicts between parallel branches
        results["potential_conflicts"] = self._detect_conflicts(results["feature_branches"])

        # Generate recommendations
        if len(results["feature_branches"]) > 3:
            results["recommendations"].append("Many parallel branches detected - consider merging completed work")

        stale_branches = [b for b in results["feature_branches"] if b.get("days_behind", 0) > 7]
        if stale_branches:
            results["recommendations"].append(f"{len(stale_branches)} branches are >7 days behind main - rebase recommended")

        return results

    def _get_main_branch(self) -> str:
        """Detect main branch name (main or master)."""
        try:
            result = subprocess.run(
                ["git", "branch", "-l", "main", "master"],
                capture_output=True, text=True, check=True
            )
            branches = result.stdout.strip().split('\n')
            for b in branches:
                b = b.strip().replace('* ', '')
                if b in ['main', 'master']:
                    return b
            return "main"
        except subprocess.CalledProcessError:
            return "main"

    def _get_feature_branches(self) -> List[str]:
        """Get all feature/fix/refactor branches."""
        branches = []
        try:
            result = subprocess.run(
                ["git", "branch", "-a"],
                capture_output=True, text=True, check=True
            )
            for line in result.stdout.strip().split('\n'):
                branch = line.strip().replace('* ', '').replace('remotes/origin/', '')
                if branch.startswith(('feat/', 'fix/', 'refactor/', 'test/', 'docs/')):
                    if branch not in branches:
                        branches.append(branch)
        except subprocess.CalledProcessError:
            pass
        return branches

    def _get_branch_info(self, branch: str, main_branch: str) -> Optional[dict]:
        """Get detailed info about a branch."""
        try:
            # Get commits ahead/behind main
            result = subprocess.run(
                ["git", "rev-list", "--left-right", "--count", f"{main_branch}...{branch}"],
                capture_output=True, text=True, check=True
            )
            parts = result.stdout.strip().split('\t')
            behind = int(parts[0]) if len(parts) > 0 else 0
            ahead = int(parts[1]) if len(parts) > 1 else 0

            # Get last commit date
            result = subprocess.run(
                ["git", "log", "-1", "--format=%cr", branch],
                capture_output=True, text=True, check=True
            )
            last_commit = result.stdout.strip()

            # Get modified files
            result = subprocess.run(
                ["git", "diff", "--name-only", f"{main_branch}...{branch}"],
                capture_output=True, text=True, check=True
            )
            files = [f for f in result.stdout.strip().split('\n') if f]

            # Calculate days behind (approximate)
            days_behind = 0
            if behind > 0:
                result = subprocess.run(
                    ["git", "log", "-1", "--format=%ct", main_branch],
                    capture_output=True, text=True, check=True
                )
                main_time = int(result.stdout.strip())
                result = subprocess.run(
                    ["git", "merge-base", main_branch, branch],
                    capture_output=True, text=True, check=True
                )
                base_commit = result.stdout.strip()
                result = subprocess.run(
                    ["git", "log", "-1", "--format=%ct", base_commit],
                    capture_output=True, text=True, check=True
                )
                base_time = int(result.stdout.strip())
                days_behind = (main_time - base_time) // 86400

            return {
                "name": branch,
                "ahead": ahead,
                "behind": behind,
                "last_commit": last_commit,
                "files_changed": len(files),
                "files": files[:10],  # Limit to first 10
                "days_behind": days_behind,
                "needs_rebase": behind > 0
            }
        except subprocess.CalledProcessError:
            return None

    def _detect_conflicts(self, branches: List[dict]) -> List[dict]:
        """Detect potential conflicts between parallel branches."""
        conflicts = []
        file_to_branches = {}

        # Build file -> branches mapping
        for branch in branches:
            for f in branch.get("files", []):
                if f not in file_to_branches:
                    file_to_branches[f] = []
                file_to_branches[f].append(branch["name"])

        # Find files modified by multiple branches
        for f, branch_list in file_to_branches.items():
            if len(branch_list) > 1:
                conflicts.append({
                    "file": f,
                    "branches": branch_list,
                    "severity": "high" if len(branch_list) > 2 else "medium"
                })

        return conflicts


def format_assessment(assessment: RiskAssessment) -> str:
    """Format assessment for display."""
    icons = {
        RiskLevel.SAFE: "✅",
        RiskLevel.CAUTION: "⚠️",
        RiskLevel.DANGEROUS: "🚨",
        RiskLevel.BLOCKED: "🛑"
    }

    lines = [
        f"\n{'='*50}",
        f"Git Safety Check",
        f"{'='*50}",
        f"",
        f"Command: {assessment.command}",
        f"Risk Level: {icons[assessment.level]} {assessment.level.value}",
    ]

    if assessment.warnings:
        lines.append("")
        lines.append("Warnings:")
        for warning in assessment.warnings:
            lines.append(f"  - {warning}")

    if assessment.recommendations:
        lines.append("")
        lines.append("Recommendations:")
        for rec in assessment.recommendations:
            lines.append(f"  - {rec}")

    if assessment.requires_confirmation:
        lines.append("")
        lines.append("⚠️  This operation requires explicit confirmation")

    lines.append(f"{'='*50}")
    return "\n".join(lines)


def format_repo_state(state: dict) -> str:
    """Format repo state for display."""
    lines = [
        f"\n{'='*50}",
        f"Repository State Analysis",
        f"{'='*50}",
        f"",
        f"Current branch: {state['branch']}",
        f"Uncommitted changes: {'Yes' if state['uncommitted_changes'] else 'No'}",
        f"Unpushed commits: {state['unpushed_commits']}",
        f"Stashes: {state['stash_count']}",
    ]

    if state["warnings"]:
        lines.append("")
        lines.append("Warnings:")
        for warning in state["warnings"]:
            lines.append(f"  ⚠️  {warning}")

    if state["recommendations"]:
        lines.append("")
        lines.append("Recommendations:")
        for rec in state["recommendations"]:
            lines.append(f"  - {rec}")

    lines.append(f"{'='*50}")
    return "\n".join(lines)


def format_parallel_status(status: dict) -> str:
    """Format parallel development status for display."""
    lines = [
        f"\n{'='*60}",
        f"并行开发分支状态 (Parallel Development Status)",
        f"{'='*60}",
        f"",
        f"主分支: {status['main_branch']}",
        f"当前分支: {status['current_branch']}",
        f"活跃特性分支: {len(status['feature_branches'])}",
    ]

    if status["feature_branches"]:
        lines.append("")
        lines.append("分支详情:")
        lines.append("-" * 60)

        for branch in status["feature_branches"]:
            rebase_icon = "🔄" if branch["needs_rebase"] else "✅"
            lines.append(f"  {rebase_icon} {branch['name']}")
            lines.append(f"     ↑{branch['ahead']} commits ahead, ↓{branch['behind']} behind main")
            lines.append(f"     最后提交: {branch['last_commit']}")
            lines.append(f"     修改文件数: {branch['files_changed']}")
            if branch["needs_rebase"]:
                lines.append(f"     ⚠️  需要 rebase (落后 {branch['days_behind']} 天)")
            lines.append("")

    if status["potential_conflicts"]:
        lines.append("")
        lines.append("⚠️  潜在冲突检测:")
        lines.append("-" * 60)
        for conflict in status["potential_conflicts"]:
            severity_icon = "🔴" if conflict["severity"] == "high" else "🟡"
            lines.append(f"  {severity_icon} {conflict['file']}")
            lines.append(f"     被修改于: {', '.join(conflict['branches'])}")

    if status["recommendations"]:
        lines.append("")
        lines.append("建议:")
        for rec in status["recommendations"]:
            lines.append(f"  💡 {rec}")

    if not status["feature_branches"]:
        lines.append("")
        lines.append("✅ 没有活跃的特性分支")

    lines.append(f"{'='*60}")
    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python git_safety_check.py <git-command>")
        print("  python git_safety_check.py --analyze-repo")
        print("  python git_safety_check.py --parallel-status")
        sys.exit(1)

    checker = GitSafetyChecker()

    if sys.argv[1] == "--analyze-repo":
        state = checker.analyze_repo_state()
        print(format_repo_state(state))
    elif sys.argv[1] == "--parallel-status":
        status = checker.analyze_parallel_status()
        print(format_parallel_status(status))
    else:
        command = " ".join(sys.argv[1:])
        assessment = checker.analyze_command(command)
        print(format_assessment(assessment))

        # Exit with non-zero if dangerous
        if assessment.level == RiskLevel.DANGEROUS:
            sys.exit(1)


if __name__ == "__main__":
    main()
