#!/bin/bash

BASE_BACKUP_DIR="$HOME/preferences_backup"
CURRENT_DATE=$(date "+%d.%m.%Y")
BACKUP_DIR="${BASE_BACKUP_DIR}_${CURRENT_DATE}"

PREFERENCES_DIRS=(
  "$HOME/Library/Preferences"
  "/Library/Preferences"
)

mkdir -p "$BACKUP_DIR"

for dir in "${PREFERENCES_DIRS[@]}"; do
  rsync -avz "$dir" "$BACKUP_DIR"
done

zip -vr $BACKUP_DIR.zip $BACKUP_DIR -x '*.DS_Store'

# cleanup
CURRENT_TIME=$(date "+%H:%M:%S")
clear
echo "Backup completed successfully at $CURRENT_TIME."
echo "Zip file location: '$BACKUP_DIR.zip'."