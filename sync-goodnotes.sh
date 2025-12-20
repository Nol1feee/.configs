# задача скрипта - автоматически экспортировать всё из goodnotes в obsidian.
# Нужен скрипт, т.к. obsidian у меня в icloud drive, а goodnotes напрямую не может работать с icloud drive -> это рабочий костыль, работающий благодаря автоматическому экспорту goodnotes в google drive.

#!/bin/bash

SRC="TODO:from (like google drive)"
DEST="TODO: where (like obsidian in icloud drive)"

mkdir -p "$DEST"

updated=0

find "$SRC" -type f -name "*.pdf" | while read -r srcfile; do
  relpath="${srcfile#$SRC/}"
  destfile="$DEST/$relpath"
  destdir="$(dirname "$destfile")"
  mkdir -p "$destdir"

  if [ ! -f "$destfile" ] || [ "$srcfile" -nt "$destfile" ]; then
    echo "$(date): Обновляю: $relpath"
    cp -f "$srcfile" "$destfile"
    updated=1
  fi
done

if [ "$updated" -eq 1 ]; then
  osascript -e 'display notification "GoodNotes → Obsidian: обновлены PDF" with title "Синхронизация завершена" sound name "Submarine"'
fi

# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
#  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#   <key>Label</key>
#   <string>com.razdobudko.syncgoodnotes</string>

#   <key>ProgramArguments</key>
#   <array>
#     <string>/bin/bash</string>
#     <string>/Users/razdobudko/Scripts/sync-goodnotes.sh</string>
#   </array>

#   <key>StartInterval</key>
#   <integer>3600</integer>

#   <key>RunAtLoad</key>
#   <true/>

#   <key>StandardErrorPath</key>
#   <string>/tmp/syncgoodnotes.err</string>
#   <key>StandardOutPath</key>
#   <string>/tmp/syncgoodnotes.out</string>
# </dict>
# </plist>

# launchctl load ~/Library/LaunchAgents/com.razdobudko.syncgoodnotes.plist (авто запуск скрипта раз в X времени)
