#!/bin/bash

set -euo pipefail

: "${GOODNOTES_EXPORT_DIR:?Set GOODNOTES_EXPORT_DIR to the exported GoodNotes directory}"
: "${OBSIDIAN_VAULT_DIR:?Set OBSIDIAN_VAULT_DIR to the destination Obsidian directory}"

if [[ ! -d "$GOODNOTES_EXPORT_DIR" ]]; then
  echo "GoodNotes export directory does not exist: $GOODNOTES_EXPORT_DIR" >&2
  exit 1
fi

mkdir -p "$OBSIDIAN_VAULT_DIR"
updated=0

while IFS= read -r -d '' source_file; do
  relative_path="${source_file#"$GOODNOTES_EXPORT_DIR"/}"
  destination_file="$OBSIDIAN_VAULT_DIR/$relative_path"
  mkdir -p "$(dirname "$destination_file")"

  if [[ ! -f "$destination_file" || "$source_file" -nt "$destination_file" ]]; then
    echo "Updating: $relative_path"
    cp -p "$source_file" "$destination_file"
    updated=1
  fi
done < <(find "$GOODNOTES_EXPORT_DIR" -type f -name '*.pdf' -print0)

if [[ "$updated" -eq 1 ]] && command -v osascript >/dev/null 2>&1; then
  osascript -e 'display notification "GoodNotes → Obsidian: PDF files updated" with title "Sync complete"'
fi
