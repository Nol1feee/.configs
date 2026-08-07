# Mac migration checklist

Срез старого рабочего Mac от 2026-08-07. Это дополнение к автоматическому
bootstrap, а не архив секретов или пользовательских данных.

## Перед сдачей старого Mac

- [ ] Сделать зашифрованный backup на разрешённый носитель.
- [ ] Не стирать старый Mac до полного рабочего дня на новом.
- [ ] Экспортировать Raycast через `Export Settings & Data` в зашифрованный
  `.rayconfig`. Экспорт включает extensions, hotkeys, aliases, snippets,
  quicklinks и настройки: <https://manual.raycast.com/import-export>.
- [ ] Включить и проверить Arc Sync, сохранить Recovery Card. Arc Sync не
  переносит passwords, extensions, profiles, history, custom shortcuts и Air
  Traffic Control: <https://resources.arc.net/hc/en-us/articles/20272860828823-Arc-Sync>.
- [ ] Запустить OrbStack и проверить containers/volumes. Нужные данные
  экспортировать отдельно.
- [ ] Проверить локальный PostgreSQL 16 и сделать logical dump нужных баз.
- [ ] Проверить, что активный Obsidian vault `~/Downloads/zettle` полностью
  синхронизирован через Syncthing.
- [ ] Проверить локальное состояние Hermes (`~/.hermes`, около 2.5 GB) и решить,
  нужно ли оно или достаточно чистой переустановки.
- [ ] Сохранить рабочие файлы TickNotch/TG WS Proxy, если их нельзя заново собрать.

## Приложения

### Уже находятся в Brewfile

Arc, ChatGPT, Claude, Dataflare, Ghostty, Insomnia, Karabiner-Elements, Obsidian,
OrbStack, Raycast, Syncthing, Telegram, TickTick, Tunnelblick, Zed, macFUSE и
JetBrains Mono Nerd Font.

### Установлены, но пока не находятся в Brewfile

Для следующих приложений существуют подходящие Homebrew casks, но их ещё нужно
осознанно добавить:

- Handy (`handy`)
- Happ (`happ`)
- Spokenly (`spokenly`)
- TypeWhisper (`typewhisper`)
- Yandex Browser (`yandex`)
- Yandex Disk (`yandex-disk`)
- Zoom (`zoom`)

Не добавлять cask `orca`: Homebrew устанавливает Plotly Orca, а на старом Mac
стоит Stably AI Orca (`com.stablyai.orca`).

### Ручная или корпоративная установка

- Microsoft Excel — App Store.
- Self Service, ServiceDesk Remote Support, Skotty — корпоративная установка.
- Yandex Messenger, Yandex Telemost — корпоративный источник.
- Hermes, TickNotch, TG WS Proxy, Stably AI Orca — отдельная установка/сборка.

### CLI-пробел

В `Brewfile` пока нет `ripgrep`, хотя `scripts/check.sh` использует `rg`. До
исправления safety scan будет пропущен на чистой машине.

## Конфиги и локальная автоматизация

### Уже находятся в репозитории

- `.zshrc`, `.zprofile`, `.bashrc`, antidote plugin list.
- Ghostty, Karabiner, lazygit, Neovim.
- Переносимая часть Zed settings, keymap и tasks.

### Зафиксированы, но пока не автоматизированы

- Zed extensions: `dockerfile`, `git-firefly`, `html`, `make`, `sql`, `toml`, `xml`.
- `~/.local/bin/arc-automount.sh` и
  `~/Library/LaunchAgents/com.yandex.arc-mount.plist`.
- `~/.local/bin/arc-slot`, `arc-wt`, `pssh`, `hermes`, `ya`.
- `~/Documents/Codex-global/arc-worktrees.md`.
- Codex user layer: `~/.codex/config.toml`, `~/.codex/AGENTS.md`,
  `~/.agents/skills`, `~/.codex/memories`.
- Amp/Devin local configs under `~/.config/amp` and `~/.config/devin`.

Текущий Arcadia LaunchAgent содержит абсолютный путь старого пользователя.
Текущий automount также удаляет `.arcadia-store` после неудачной попытки mount.
Перед добавлением в bootstrap его нужно сделать переносимым и убрать опасную
автоматическую очистку store.

## Снимок настроек macOS

Эти настройки обнаружены на старом Mac, но пока не применяются репозиторием:

- languages: English и RussianWin;
- locale: `en_RU`;
- keyboard repeat: `InitialKeyRepeat=15`, `KeyRepeat=2`;
- tap-to-click включён;
- Dock: слева, auto-hide, размер 39;
- правый нижний Hot Corner настроен;
- Finder открывает каталоги в list view.

В будущем безопасную часть можно оформить отдельным `macos/defaults.sh` с
dry-run. Не следует целиком копировать plist-файлы между версиями macOS.

### Настраивается вручную

- Touch ID, FileVault и Apple Pay.
- Wi-Fi, Bluetooth и VPN.
- Display scaling, wallpaper, sound и microphone/camera selection.
- Notifications, Focus, Control Center и menu bar.
- Privacy permissions: Accessibility, Screen Recording, Full Disk Access,
  Microphone, Camera и Automation.
- Default browser, default mail app и login/background items.
- Dock composition и пользовательские keyboard shortcuts.

## Доступы и секреты

- [ ] Создать новый SSH-ключ на новом Mac и зарегистрировать public key.
- [ ] Перенести Tunnelblick profile только через защищённый канал.
- [ ] Войти заново в GitHub, Codex и приложения; не копировать `auth.json`.
- [ ] Добавить новый Syncthing device, не коммитить device private key.
- [ ] Восстановить Keychain через Apple Account или одобренный компанией способ.
- [ ] Получить корпоративный CA, Skotty и остальные credentials через штатную
  установку.

Никогда не коммитить `.ssh`, VPN keys, `.env`, `.netrc`, `.npmrc`, `.pypirc`,
Raycast export, browser profiles, keychain exports или Syncthing private keys.

## Что не копировать целиком

- `~/.ya`: почти всё является build cache и tool cache.
- Arcadia mount и arc worktrees: создать заново.
- `~/.codex`: не переносить caches, logs, live SQLite и `auth.json`.
- OrbStack data directory: экспортировать нужные volumes, а не копировать VM state.
- PostgreSQL data directory между разными установками: использовать dump/restore.

## Проверка нового Mac

- [ ] `./scripts/check.sh` проходит полностью.
- [ ] Новый terminal открывается без ошибок, работают fzf/starship/antidote.
- [ ] VPN подключается, SSH-доступ и Skotty работают.
- [ ] Arcadia смонтирована, `ya` и `arc-wt` работают.
- [ ] Zed открывает Arcadia, затем отдельно настроен актуальный `gopls`.
- [ ] Codex видит AGENTS.md, skills и memories после безопасного импорта.
- [ ] Raycast settings/extensions восстановлены из зашифрованного export.
- [ ] Arc profiles, extensions и passwords проверены вручную.
- [ ] Syncthing завершил sync `~/Downloads/zettle`, Obsidian открывает нужный vault.
- [ ] Нужные OrbStack volumes и PostgreSQL-базы доступны.
- [ ] TickNotch, Hermes и остальные кастомные приложения запускаются.
