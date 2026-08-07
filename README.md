# apps-dotfiles

Воспроизводимая базовая настройка рабочего Mac: приложения через Homebrew, shell,
Ghostty, Zed, Karabiner-Elements, Neovim и вспомогательные скрипты.

Репозиторий намеренно **не содержит** пароли, токены, SSH/VPN-ключи, browser
profiles, `auth.json`, корпоративные сертификаты и локальные базы.

## Быстрый старт на новом Mac

1. Пройти корпоративную настройку: Self Service, сертификаты, VPN и Skotty.
2. Установить Xcode Command Line Tools и [Homebrew](https://brew.sh/).
3. Клонировать репозиторий в постоянное место:

   ```bash
   git clone https://github.com/Nol1feee/apps-dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

4. Сначала посмотреть план без изменений:

   ```bash
   ./scripts/bootstrap.sh
   ```

5. Установить приложения и подключить dotfiles:

   ```bash
   ./scripts/bootstrap.sh --apply --brew
   ```

Существующие конфиги не удаляются: перед созданием symlink они переносятся в
`~/.dotfiles-backup-<timestamp>`.

## Что устанавливается

- CLI: antidote, fzf, gh, lazygit, Neovim, Node.js, PostgreSQL 16, Python 3.13,
  poppler, pre-commit и starship.
- Apps: Arc, ChatGPT, Claude, Dataflare, Ghostty, Insomnia, Karabiner-Elements,
  Obsidian, OrbStack, Raycast, Syncthing, Telegram, TickTick, Tunnelblick и Zed.
- JetBrains Mono Nerd Font и macFUSE.

Microsoft Excel и корпоративные приложения устанавливаются отдельно через App
Store или Self Service.

## Что переносится вручную

### Доступы

- Создать новый SSH-ключ и зарегистрировать публичную часть в нужных системах.
- Импортировать рабочий Tunnelblick-профиль только через защищённый канал.
- Войти заново в GitHub, Codex, браузер и остальные приложения.
- Добавить новый Syncthing device вместо копирования приватного device key.
- Не коммитить `~/.codex/auth.json`, `~/.ssh`, `.env`, keychain exports или VPN keys.

### Данные

- Проверить локальные PostgreSQL-базы и при необходимости перенести через dump.
- Запустить OrbStack на старом Mac, проверить containers/volumes и экспортировать
  только нужные данные.
- Дождаться полной синхронизации Obsidian/GoodNotes/TickTick через iCloud.
- Arcadia и `~/.ya` не копировать: mount и build cache создаются заново.

### Codex

Полезный переносимый слой: `~/.codex/config.toml` после ручной проверки на
машинные пути, `~/.codex/AGENTS.md`, `~/.agents/skills` и `~/.codex/memories`.
Не переносить `auth.json`, кэши, логи и живые SQLite-файлы.

## Zed и Arcadia

В `zed/settings.json` лежат только переносимые UI/agent-настройки. Блок `gopls`
из старого Mac исключён: он содержал абсолютные пути `~/.ya/tools/v4/<tool-id>`,
которые меняются между машинами.

Также намеренно исключён `session.trust_all_worktrees = true`. На новом Mac лучше
доверять рабочим каталогам явно. Arcadia-specific LSP настраивается заново после
mount Arcadia и установки `ya` tools.

## GoodNotes → Obsidian

```bash
GOODNOTES_EXPORT_DIR="$HOME/path/to/GoodNotes" \
OBSIDIAN_VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault" \
./scripts/sync-goodnotes.sh
```

Сначала проверьте копирование вручную, затем при необходимости создайте LaunchAgent.

## Проверка

```bash
./scripts/check.sh
```

Проверка валидирует shell-конфиги, Karabiner JSON, Brewfile и отсутствие очевидных
секретов или абсолютных путей к домашнему каталогу конкретного пользователя.
