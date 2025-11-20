## Apps

- [raycast (like spotlight)](https://www.raycast.com/)
  - [kill-process](raycast://extensions/rolandleth/kill-process)
  - [open-ports](raycast://extensions/lucaschultz/port-manager/open-ports)
  - [generate-random-password](raycast://extensions/joshuaiz/password-generator/generate-random-password)
  - [uuid-generator](raycast://extensions/jmaeso/uuid-generator)
  - [default-profile](raycast://extensions/vitoorgomes/google-meet/default-profile)
  - [toggle-fullscreen](raycast://extensions/raycast/window-management/toggle-fullscreen)
  - [ask](raycast://extensions/ViGeng/deepseeker/ask) (only translate)
  - [confetti](raycast://extensions/raycast/raycast/confetti)
- [arc (browser)](https://arc.net/)
- [zed (code editor)](https://zed.dev/)

- [ghostty](https://ghostty.org/)
```bash (~/.config/ghostty/config)
theme = Catppuccin Mocha
background-opacity = 0.55
background-blur-radius = 25
background-image-opacity = 0
window-decoration = true
mouse-hide-while-typing = true
macos-option-as-alt = true
font-size = 19
```

- [dataflare (DB manager)](https://dataflare.app/)
- [orbstack (like docker)](https://orbstack.dev/)
- [insomnia (like postman)](https://insomnia.rest/)
- [ticktick](https://www.ticktick.com/)
- [obsidian (like notes)](https://obsidian.md/)

## CLI utils

- [lazygit](https://github.com/jesseduffield/lazygit)
```bash (~/Library/Application\ Support/lazygit/config.yml)
git:
  pagers:
    - pager: delta --dark --paging=never --line-numbers --syntax-theme="Monokai Extended"

gui:
  showIcons: true
  showCommandLog: true
  commandLogSize: 8
  language: 'en'
  showFileTree: true

refresher:
  refreshInterval: 10
  fetchInterval: 60
```

- [claude code](https://www.claude.com/product/claude-code)
- [pre-commit](https://pre-commit.com/)


# zsh

```bash (~/.zshrc)
# === Плагины через antidote ===
source /opt/homebrew/share/antidote/antidote.zsh
antidote load ~/.zsh_plugins.txt

# === История команд ===
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt inc_append_history      # писать историю сразу
setopt share_history           # общая история между вкладками
setopt hist_ignore_all_dups    # не дублировать команды

# === Комплиты ===
autoload -Uz compinit
compinit

# === FZF (история поиска) ===
eval "$(fzf --zsh)"

# === Алиасы ===
alias lg="lazygit"
alias gsw='git switch'
alias gc='git commit'
alias gp='git push'
alias ga='git add'

# === Тема промпта (вместо oh-my-zsh) ===
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
```

```bash (~/.zsh_plugins.txt)
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
```
