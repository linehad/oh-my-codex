#!/usr/bin/env bash
set -euo pipefail

force=0
destination="${CODEX_HOME:-$HOME/.codex}/skills"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      force=1
      shift
      ;;
    --dest)
      destination="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
source_root="$repo_root/skills"

mkdir -p "$destination"

for skill_dir in "$source_root"/*; do
  [[ -d "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
  target="$destination/$name"

  if [[ -e "$target" ]]; then
    if [[ "$force" -ne 1 ]]; then
      echo "Skipping existing skill: $name"
      continue
    fi
    rm -rf "$target"
  fi

  cp -R "$skill_dir" "$destination/"
  echo "Installed skill: $name"
done

cp "$repo_root/LICENSE.md" "$destination/_oh-my-codex-LICENSE.md"
cp "$repo_root/THIRD_PARTY_NOTICES.md" "$destination/_oh-my-codex-THIRD_PARTY_NOTICES.md"

echo "Restart Codex to pick up new skills."
