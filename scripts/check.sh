#!/bin/bash

set -uo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILURES=0

pass() { echo "[ok] $1"; }
fail() { echo "[fail] $1" >&2; FAILURES=$((FAILURES + 1)); }

if zsh -n "$DOTFILES_ROOT/home/.zshrc" && zsh -n "$DOTFILES_ROOT/home/.zprofile"; then
  pass "zsh syntax"
else
  fail "zsh syntax"
fi

if bash -n "$DOTFILES_ROOT/home/.bashrc" && \
  bash -n "$DOTFILES_ROOT/scripts/bootstrap.sh" && \
  bash -n "$DOTFILES_ROOT/scripts/check.sh" && \
  bash -n "$DOTFILES_ROOT/scripts/sync-goodnotes.sh"; then
  pass "bash syntax"
else
  fail "bash syntax"
fi

if command -v ruby >/dev/null 2>&1 && \
  ruby -rjson -e 'ARGV.each { |path| JSON.parse(File.read(path)) }' \
    "$DOTFILES_ROOT/config/karabiner/karabiner.json" \
    "$DOTFILES_ROOT/zed/settings.json" \
    "$DOTFILES_ROOT/zed/tasks.json"; then
  pass "portable JSON files"
else
  fail "portable JSON files"
fi

if command -v brew >/dev/null 2>&1; then
  if brew bundle list --file "$DOTFILES_ROOT/Brewfile" >/dev/null; then
    pass "Brewfile syntax"
  else
    fail "Brewfile syntax"
  fi
else
  echo "[skip] Brewfile syntax: Homebrew not installed"
fi

if command -v rg >/dev/null 2>&1; then
  HARD_CODED_PATHS="$(rg -l '/Users/[^/$ ]+' "$DOTFILES_ROOT" \
    --glob '!.git/**' --glob '!scripts/check.sh' || true)"
  POSSIBLE_SECRETS="$(rg -l \
    '(BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|gh[pousr]_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{20,})' \
    "$DOTFILES_ROOT" --glob '!.git/**' --glob '!scripts/check.sh' || true)"

  if [[ -z "$HARD_CODED_PATHS" ]]; then
    pass "no hard-coded /Users paths"
  else
    fail "hard-coded /Users paths in: $HARD_CODED_PATHS"
  fi

  if [[ -z "$POSSIBLE_SECRETS" ]]; then
    pass "no obvious secret material"
  else
    fail "possible secret material in: $POSSIBLE_SECRETS"
  fi
else
  echo "[skip] repository safety scan: rg not installed"
fi

if (( FAILURES > 0 )); then
  echo "$FAILURES check(s) failed." >&2
  exit 1
fi

echo "All checks passed."
