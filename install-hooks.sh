#!/bin/sh
# Symlink a house pre-commit hook into one or more git repos.
# Usage: ./install-hooks.sh [--rust] [repo-dir ...]   (defaults to the current dir)
#   (no flag)  advisory prose check only — never blocks.
#   --rust     prose check + a BLOCKING `cargo fmt --check` (self-disables without
#              a Cargo.toml, so it only gates real Rust repos).
# Re-run safely; it overwrites only the pre-commit symlink and skips non-symlinks.
hookname=pre-commit-prose
if [ "$1" = "--rust" ]; then hookname=pre-commit-rust; shift; fi
hook="$(cd "$(dirname "$0")" && pwd)/hooks/$hookname"
for repo in "${@:-.}"; do
  d="$repo/.git/hooks"
  if [ ! -d "$d" ]; then echo "skip (not a git repo): $repo"; continue; fi
  if [ -e "$d/pre-commit" ] && [ ! -L "$d/pre-commit" ]; then
    echo "skip (existing non-symlink pre-commit): $repo"; continue
  fi
  ln -sf "$hook" "$d/pre-commit" && echo "installed ($hookname): $repo"
done
