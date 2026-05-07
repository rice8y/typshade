#!/usr/bin/env python3
"""Generate release notes from first-parent commits.

GitHub's generated release notes are PR-centric. Typshade also uses issue
references in conventional commit messages, for example
`fix: apply command helpers during rendering (fixes #1)`. This script keeps the
usual "by @user in #123" shape while recognizing those commit-message
references directly. Commits that do not reference an issue or pull request are
left out of the generated "What's Changed" list.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path


ISSUE_REF_RE = re.compile(r"(?<![\w/])#(\d+)\b")
MERGE_PR_RE = re.compile(r"^Merge pull request #(\d+) from .+$")
CLOSING_REF_RE = re.compile(
    r"\s*\((?:close[sd]?|fix(?:e[sd])?|resolve[sd]?)\s+#[0-9]+"
    r"(?:\s*,\s*#[0-9]+)*\)\s*$",
    re.IGNORECASE,
)
TRAILING_PAREN_RE = re.compile(r"\s+\(#[0-9]+(?:\s*,\s*#[0-9]+)*\)\s*$")
TRAILING_REF_RE = re.compile(r"\s+#[0-9]+(?:\s+#[0-9]+)*\s*$")


@dataclass
class Commit:
    sha: str
    subject: str
    author_name: str


def git(*args: str, allow_failure: bool = False) -> str:
    result = subprocess.run(
        ("git", *args),
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        if allow_failure:
            return ""
        sys.stderr.write(result.stderr)
        raise SystemExit(result.returncode)
    return result.stdout.strip()


def tag_exists(tag: str) -> bool:
    return bool(git("rev-parse", "--verify", "--quiet", f"refs/tags/{tag}", allow_failure=True))


def release_range(tag: str) -> tuple[str, str, str]:
    rev = tag if tag_exists(tag) else "HEAD"
    previous = git("describe", "--tags", "--abbrev=0", f"{rev}^", allow_failure=True)
    spec = f"{previous}..{rev}" if previous else rev
    return rev, previous, spec


def commits_in_range(spec: str) -> list[Commit]:
    raw = git(
        "log",
        "--first-parent",
        "--reverse",
        "--format=%H%x1f%s%x1f%an%x1e",
        spec,
        allow_failure=True,
    )
    commits: list[Commit] = []
    for record in raw.split("\x1e"):
        record = record.strip()
        if not record:
            continue
        parts = record.split("\x1f")
        if len(parts) != 3:
            continue
        commits.append(Commit(parts[0], parts[1], parts[2]))
    return commits


def github_json(repo: str, path: str) -> dict | None:
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if not token:
        return None

    request = urllib.request.Request(
        f"https://api.github.com/repos/{repo}/{path}",
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=10) as response:
            return json.loads(response.read().decode("utf-8"))
    except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError):
        return None


def commit_author(repo: str, commit: Commit) -> str:
    data = github_json(repo, f"commits/{commit.sha}")
    login = None
    if data:
        author = data.get("author")
        if isinstance(author, dict):
            login = author.get("login")
    return f"@{login}" if login else commit.author_name


def pr_title_and_author(repo: str, number: str) -> tuple[str | None, str | None]:
    data = github_json(repo, f"pulls/{number}")
    if not data:
        return None, None
    title = data.get("title")
    user = data.get("user")
    login = user.get("login") if isinstance(user, dict) else None
    return title, f"@{login}" if login else None


def unique_refs(subject: str) -> list[str]:
    refs: list[str] = []
    for ref in ISSUE_REF_RE.findall(subject):
        if ref not in refs:
            refs.append(ref)
    return refs


def clean_subject(subject: str) -> str:
    out = CLOSING_REF_RE.sub("", subject)
    out = TRAILING_PAREN_RE.sub("", out)
    out = TRAILING_REF_RE.sub("", out)
    return out.strip()


def release_line(repo: str, commit: Commit) -> str | None:
    merge = MERGE_PR_RE.match(commit.subject)
    if merge:
        number = merge.group(1)
        title, author = pr_title_and_author(repo, number)
        subject = title or clean_subject(commit.subject)
        by = author or commit_author(repo, commit)
        return f"- {subject} by {by} in #{number}"

    refs = unique_refs(commit.subject)
    if not refs:
        return None

    subject = clean_subject(commit.subject)
    by = commit_author(repo, commit)
    issue_suffix = f" in {', '.join(f'#{ref}' for ref in refs)}"
    return f"- {subject} by {by}{issue_suffix}"


def write_notes(repo: str, tag: str, previous: str, commits: list[Commit], output: Path) -> None:
    lines = ["## What's Changed", ""]
    release_lines = [line for commit in commits if (line := release_line(repo, commit))]

    if release_lines:
        lines.extend(release_lines)
    else:
        lines.append("- No issue or pull request references found.")

    lines.append("")
    if previous:
        lines.append(f"**Full Changelog**: https://github.com/{repo}/compare/{previous}...{tag}")
    else:
        lines.append(f"**Full Changelog**: https://github.com/{repo}/commits/{tag}")
    lines.append("")

    output.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    _, previous, spec = release_range(args.tag)
    commits = commits_in_range(spec)
    write_notes(args.repo, args.tag, previous, commits, Path(args.output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
