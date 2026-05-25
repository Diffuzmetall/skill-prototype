#!/usr/bin/env bash
set -euo pipefail

# Install the prototype skill into common agent skill directories.
# Usage: curl -fsSL https://raw.githubusercontent.com/Diffuzmetall/skill-prototype/main/install.sh | bash

REPO="${SKILL_PROTOTYPE_REPO:-https://github.com/Diffuzmetall/skill-prototype.git}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 "$REPO" "$TMP/repo"

install_dir() {
  local target="$1"
  if [[ ! -d "$(dirname "$target")" ]]; then
    echo "skip: $(dirname "$target") does not exist"
    return 0
  fi
  mkdir -p "$target"
  cp "$TMP/repo/SKILL.md" "$TMP/repo/LOGIC.md" "$TMP/repo/UI.md" "$target/"
  echo "installed -> $target"
}

install_dir "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}/prototype"
install_dir "${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}/prototype"
install_dir "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}/prototype"

echo
echo "Done. Invoke with /prototype or attach the skill in your agent settings."
