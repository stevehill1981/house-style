#!/bin/sh
# Symlink the advisory prose pre-commit hook into one or more git repos.
# Usage: ./install-hooks.sh [repo-dir ...]   (defaults to the current dir)
# Re-run safely; it overwrites only the pre-commit symlink.
hook="$(cd "$(dirname "$0")" && pwd)/hooks/pre-commit-prose"
for repo in "${@:-.}"; do
  d="$repo/.git/hooks"
  if [ ! -d "$d" ]; then echo "skip (not a git repo): $repo"; continue; fi
  if [ -e "$d/pre-commit" ] && [ ! -L "$d/pre-commit" ]; then
    echo "skip (existing non-symlink pre-commit): $repo"; continue
  fi
  ln -sf "$hook" "$d/pre-commit" && echo "installed: $repo"
done
