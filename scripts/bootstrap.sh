#!/bin/bash

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_HOME="${DOTFILES_TARGET_HOME:-$HOME}"
APPLY=false
INSTALL_BREW=false

usage() {
  echo "Usage: $0 [--apply] [--brew]"
  echo "Without --apply, prints the planned changes only."
}

for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    --brew) INSTALL_BREW=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap supports macOS only." >&2
  exit 1
fi

if [[ "$INSTALL_BREW" == true ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required. Install it from https://brew.sh/ first." >&2
    exit 1
  fi

  if [[ "$APPLY" == true ]]; then
    brew bundle --file "$DOTFILES_ROOT/Brewfile"
  else
    echo "[dry-run] brew bundle --file $DOTFILES_ROOT/Brewfile"
  fi
fi

BACKUP_ROOT="$TARGET_HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
BACKUP_CREATED=false

install_link() {
  local source_path="$DOTFILES_ROOT/$1"
  local target_path="$TARGET_HOME/$2"

  if [[ ! -e "$source_path" ]]; then
    echo "Missing source: $source_path" >&2
    return 1
  fi

  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    echo "[ok] $target_path"
    return
  fi

  if [[ "$APPLY" != true ]]; then
    if [[ -e "$target_path" || -L "$target_path" ]]; then
      echo "[dry-run] backup $target_path"
    fi
    echo "[dry-run] link $target_path -> $source_path"
    return
  fi

  mkdir -p "$(dirname "$target_path")"

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    local relative_target="${target_path#"$TARGET_HOME"/}"
    local backup_target="$BACKUP_ROOT/$relative_target"
    mkdir -p "$(dirname "$backup_target")"
    mv "$target_path" "$backup_target"
    BACKUP_CREATED=true
  fi

  ln -s "$source_path" "$target_path"
  echo "[linked] $target_path"
}

install_link "home/.zshrc" ".zshrc"
install_link "home/.zprofile" ".zprofile"
install_link "home/.bashrc" ".bashrc"
install_link "home/.zsh_plugins.txt" ".zsh_plugins.txt"
install_link "config/ghostty/config" ".config/ghostty/config"
install_link "config/karabiner/karabiner.json" ".config/karabiner/karabiner.json"
install_link "config/lazygit/config.yml" "Library/Application Support/lazygit/config.yml"
install_link "config/nvim/init.vim" ".config/nvim/init.vim"
install_link "zed/keymap.json" ".config/zed/keymap.json"
install_link "zed/settings.json" ".config/zed/settings.json"
install_link "zed/tasks.json" ".config/zed/tasks.json"

if [[ "$APPLY" == true ]]; then
  if [[ "$BACKUP_CREATED" == true ]]; then
    echo "Previous files were saved to $BACKUP_ROOT"
  fi
  echo "Done. Open a new terminal and run ./scripts/check.sh"
else
  echo "Dry run only. Re-run with --apply to create links."
fi
