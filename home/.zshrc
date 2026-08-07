# Portable interactive zsh configuration.

export PATH="$HOME/.local/bin:$PATH"

if [[ -r /etc/ssl/certs/YandexInternalCA.pem ]]; then
  export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/YandexInternalCA.pem
fi

ANTIDOTE_SCRIPT=/opt/homebrew/opt/antidote/share/antidote/antidote.zsh
if [[ -r "$ANTIDOTE_SCRIPT" ]]; then
  source "$ANTIDOTE_SCRIPT"
  antidote load "$HOME/.zsh_plugins.txt"
fi
unset ANTIDOTE_SCRIPT

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups

autoload -Uz compinit
compinit

command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

alias lg='lazygit'
alias gsw='git switch'
alias gc='git commit'
alias gp='git push'
alias ga='git add'

[[ -r "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

if command -v ya >/dev/null 2>&1; then
  alias arc-wt='ya tool arc-wt'
  wt() {
    if [[ "$1" == "cd" || ( "$1" == "add" && " $* " == *" --cd "* ) ]]; then
      local worktree_dir
      worktree_dir="$(ya tool arc-wt "$@")" || return
      builtin cd "$worktree_dir"
    else
      ya tool arc-wt "$@"
    fi
  }
fi
