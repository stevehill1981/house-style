#!/bin/sh
# Symlink house git hooks into one or more git repos.
# Usage: ./install-hooks.sh [--rust] [--conventional] [repo-dir ...]
#                                                    (defaults to the current dir)
#   (no flag)       pre-commit: advisory prose check only — never blocks.
#   --rust          pre-commit: prose + a BLOCKING `cargo fmt --check`
#                   pre-push:   a BLOCKING `cargo clippy --all-targets -- -D warnings`
#                               (mirrors CI; runs once per push, not per commit).
#                   Both self-disable without a Cargo.toml, so they only gate
#                   real Rust repos.
#   --conventional  commit-msg: a BLOCKING conventional-commit prefix check.
#                   For repos whose CHANGELOG and version bump are computed from
#                   commit subjects (release-plz, git-cliff). Opt-in, because the
#                   constraint buys a repo without that tooling nothing.
# The flags combine, in any order.
# Re-run safely; it overwrites only the house symlinks and skips non-symlinks.
rust=0
conventional=0
while [ $# -gt 0 ]; do
  case "$1" in
    --rust)         rust=1; shift ;;
    --conventional) conventional=1; shift ;;
    --)             shift; break ;;
    -*)             echo "unknown flag: $1" >&2; exit 2 ;;
    *)              break ;;
  esac
done
basedir="$(cd "$(dirname "$0")" && pwd)/hooks"

# link <repo-hooks-dir> <hook-name> <source-file>: symlink one hook, skipping a
# pre-existing non-symlink so we never clobber a repo's hand-written hook.
link() {
  if [ -e "$1/$2" ] && [ ! -L "$1/$2" ]; then
    echo "skip (existing non-symlink $2): $1"
    return 0
  fi
  ln -sf "$basedir/$3" "$1/$2" && echo "installed ($3): $1/$2"
}

for repo in "${@:-.}"; do
  d="$repo/.git/hooks"
  if [ ! -d "$d" ]; then echo "skip (not a git repo): $repo"; continue; fi
  if [ "$rust" = "1" ]; then
    link "$d" pre-commit pre-commit-rust
    link "$d" pre-push pre-push-rust
  else
    link "$d" pre-commit pre-commit-prose
  fi
  if [ "$conventional" = "1" ]; then
    link "$d" commit-msg commit-msg-conventional
  fi
done
